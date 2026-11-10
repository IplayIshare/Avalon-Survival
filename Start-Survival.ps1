$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$client = Join-Path $root 'client'
if (!(Test-Path (Join-Path $client 'Albion-Online_BE.exe'))) { throw 'Chay 1-Tai-client.cmd truoc.' }
if ((Get-Content (Join-Path $client 'version.txt') -TotalCount 1) -ne 'albiononline-win32-full-1.32.030.345319') { throw 'Can dung client 1.32.030.345319.' }
if (Get-Process Albion-Online -ErrorAction SilentlyContinue) { throw 'Hay dong cua so Albion dang chay truoc khi mo Survival.' }
$catalog = Join-Path $root 'survival-catalog.json'
try {
    $value = Invoke-RestMethod -Uri 'http://157.10.201.13:18081/survival/catalog' -TimeoutSec 8
    if ($value.Build -ne '345319' -or $value.Products.Count -lt 500) { throw 'Danh muc khong hop le.' }
    foreach ($p in $value.Products) { if (!$p.Free -and ($p.Gold -lt 1 -or $p.Gold -gt 1000000)) { throw 'Gia khong hop le.' } }
    $value | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $catalog -Encoding UTF8
} catch {
    Write-Warning 'Chua tai duoc gia skin moi. Dung danh muc da luu; server van kiem tra gia khi mua.'
    if (!(Test-Path $catalog)) { throw 'Chua co danh muc Survival. Hay kiem tra ket noi va thu lai.' }
}
$script = Join-Path $root 'tools\prepare-survival-client.ps1'
$stamp = (Get-FileHash $catalog).Hash + (Get-FileHash $script).Hash
$marker = Join-Path $client 'SurvivalOriginals\applied-state.txt'
if (!(Test-Path $marker) -or (Get-Content $marker -Raw).Trim() -ne $stamp) {
    & $script -CatalogPath $catalog
    Set-Content -LiteralPath $marker -Value $stamp -Encoding ASCII
}
Start-Process -FilePath (Join-Path $client 'Albion-Online_BE.exe') -WorkingDirectory $client -ArgumentList '+server 157.10.201.13:5055'
