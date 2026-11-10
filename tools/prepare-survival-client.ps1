param([string]$SourceClient = '', [string]$CatalogPath = '')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$target = Join-Path $root 'client'
if (!$SourceClient) { $SourceClient = $target }
if (!(Test-Path (Join-Path $target 'Albion-Online.exe'))) {
    & robocopy $SourceClient $target /E /NFL /NDL /NJH /NJS /R:0 /W:0 /NP
    if ($LASTEXITCODE -ge 8) { throw 'Client copy failed.' }
}
$manifest = Get-Content (Join-Path $PSScriptRoot 'survival-client-patches.json') -Raw | ConvertFrom-Json
$originals = Join-Path $target 'SurvivalOriginals'
New-Item -ItemType Directory -Path $originals -Force | Out-Null
$sourceDll = Join-Path $originals 'GameAssembly.dll'
if (!(Test-Path $sourceDll)) { Copy-Item (Join-Path $SourceClient 'GameAssembly.dll') $sourceDll }
if ((Get-FileHash $sourceDll -Algorithm SHA256).Hash -ne $manifest.SourceSha256) { throw 'Unexpected client build; refusing to patch.' }
$bytes = [IO.File]::ReadAllBytes($sourceDll)
# Keep the original signed executable code: BattlEye rejects edited GameAssembly.dll.
[IO.File]::WriteAllBytes((Join-Path $target 'GameAssembly.dll'), $bytes)

function Read-GameXml([string]$path) {
    $des = [Security.Cryptography.DES]::Create()
    $des.Key = [byte[]](48,239,114,71,66,242,4,50); $des.IV = [byte[]](14,166,220,55,197,107,96,180)
    $encrypted = [IO.File]::ReadAllBytes($path)
    $plain = $des.CreateDecryptor().TransformFinalBlock($encrypted,0,$encrypted.Length)
    $mem = [IO.MemoryStream]::new($plain,10,($plain.Length-10))
    $stream = [IO.Compression.DeflateStream]::new($mem,[IO.Compression.CompressionMode]::Decompress)
    $reader = [IO.StreamReader]::new($stream)
    try { return ,([xml]$reader.ReadToEnd()) } finally { $reader.Dispose(); $des.Dispose() }
}
function Write-GameXml([xml]$xml, [string]$path) {
    $raw = [Text.Encoding]::UTF8.GetBytes($xml.OuterXml)
    $mem = [IO.MemoryStream]::new()
    $gzip = [IO.Compression.GZipStream]::new($mem,[IO.Compression.CompressionLevel]::Optimal,$true)
    $gzip.Write($raw,0,$raw.Length); $gzip.Dispose()
    $plain = $mem.ToArray(); $mem.Dispose()
    $des = [Security.Cryptography.DES]::Create()
    $des.Key = [byte[]](48,239,114,71,66,242,4,50); $des.IV = [byte[]](14,166,220,55,197,107,96,180)
    # The legacy reader IV differs from the client's IV in the first DES block.
    # Preserve the original decrypted header, not a fresh gzip header: otherwise
    # the native client receives invalid gzip flags and stalls at 19%.
    $originalBytes = [IO.File]::ReadAllBytes((Join-Path $sourceData ([IO.Path]::GetFileName($path))))
    $originalPlain = $des.CreateDecryptor().TransformFinalBlock($originalBytes,0,$originalBytes.Length)
    [Array]::Copy($originalPlain,0,$plain,0,10)
    try { [IO.File]::WriteAllBytes($path,$des.CreateEncryptor().TransformFinalBlock($plain,0,$plain.Length)) } finally { $des.Dispose() }
    # Round-trip verification also checks the exact file the client will read.
    $check = Read-GameXml $path
    if ($check.OuterXml -ne $xml.OuterXml) { throw "Game data round-trip failed: $path" }
}
$relativeData = 'Albion-Online_Data\StreamingAssets\GameData'
$sourceData = Join-Path $SourceClient $relativeData
$targetData = Join-Path $target $relativeData
foreach ($name in @('localization.bin','gamedata.bin','characters.bin','mountskins.bin','wardrobe.bin','emotes.bin','avatars.bin')) {
    if (!(Test-Path (Join-Path $originals $name))) { Copy-Item (Join-Path $sourceData $name) (Join-Path $originals $name) }
}
$sourceData = $originals
$loc = Read-GameXml (Join-Path $sourceData 'localization.bin')
$labels = @{
    '@STATS_GUI_TOTAL_FAME' = 'Gold'
    '@STATS_GUI_TOTAL_KILLED_PLAYERS' = 'Player Kills'
    '@REPUTATION_LEVEL_NEUTRAL' = 'Tan Binh Avalon'
    '@REPUTATION_LEVEL_POSITIVE01' = 'Chien Binh Avalon'
    '@REPUTATION_LEVEL_POSITIVE02' = 'Tinh Anh Avalon'
    '@REPUTATION_LEVEL_POSITIVE03' = 'Ba Chu Avalon'
    '@REPUTATION_LEVEL_POSITIVE04' = 'Huyen Thoai Avalon'
    '@LOGIN_EMAIL' = 'Username'
}
foreach ($key in $labels.Keys) {
    $entry = $loc.SelectSingleNode("//tu[@tuid='$key']")
    if ($null -eq $entry) { throw "Missing client label: $key" }
    foreach ($seg in $entry.SelectNodes('tuv/seg')) { $seg.InnerText = $labels[$key] }
}
Write-GameXml $loc (Join-Path $targetData 'localization.bin')
$data = Read-GameXml (Join-Path $sourceData 'gamedata.bin')
$rep = $data.SelectSingleNode('//Reputation')
$rep.SetAttribute('maxreputation','2147483647')
$points = @(1000,500,150,50,0,-1000,-3000,-10000,-20000,-50000)
$levels = $rep.SelectNodes('level')
if ($levels.Count -ne $points.Count) { throw 'Unexpected reputation levels.' }
for ($i=0; $i -lt $levels.Count; $i++) {
    $levels[$i].SetAttribute('requiredpoints',[string]$points[$i])
    foreach ($key in @('recoveryperday','pvegainfactor','gathergainfactor','attackpenalty','knockdownpenalty','killpenalty')) { $levels[$i].SetAttribute($key,'0') }
    $levels[$i].RemoveAttribute('crimeprotectionbuff')
}
Write-GameXml $data (Join-Path $targetData 'gamedata.bin')
if ($CatalogPath) {
    $catalog = Get-Content $CatalogPath -Raw | ConvertFrom-Json
    if ($catalog.Build -ne '345319') { throw 'Shop catalog is for another client build.' }
    $products = @{}
    foreach ($product in $catalog.Products) {
        if (!$product.Free) {
            if ($product.Gold -lt 1 -or $product.Gold -gt 1000000) { throw 'Invalid catalog price.' }
            $products[[string]$product.Name] = $product
        }
    }
    foreach ($name in @('characters.bin','mountskins.bin','wardrobe.bin','emotes.bin','avatars.bin')) {
        $xml = Read-GameXml (Join-Path $sourceData $name)
        foreach ($node in $xml.SelectNodes('//*')) {
            $key = if ($node.HasAttribute('reference')) { $node.GetAttribute('reference') } elseif ($node.HasAttribute('uniquename')) { $node.GetAttribute('uniquename') } else { $node.GetAttribute('name') }
            if ($products.ContainsKey($key)) {
                $product = $products[$key]
                $node.SetAttribute('goldprice', [string]$product.Gold)
                $node.SetAttribute('availablevia', 'Gold')
                $node.SetAttribute('state', $(if ($product.Enabled) { 'Buyable' } else { 'Hidden' }))
            }
        }
        Write-GameXml $xml (Join-Path $targetData $name)
    }
}
Write-Output "Survival client prepared: $target (original game code, gold/kill labels, shop prices)."
