[CmdletBinding()]
param(
    [string]$ArchivePath,
    [switch]$CheckOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$projectRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$manifest = Get-Content -LiteralPath (Join-Path $projectRoot 'client-manifest.json') -Raw | ConvertFrom-Json
$clientPath = Join-Path $projectRoot 'client'
$stagingPath = $null

function Assert-ProjectPath([string]$Path) {
    $full = [IO.Path]::GetFullPath($Path)
    $prefix = $projectRoot.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    if (-not $full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Refusing a file operation outside the player project.'
    }
    return $full
}

function Assert-ClientVersion([string]$Folder) {
    $versionPath = Join-Path $Folder 'version.txt'
    if (-not (Test-Path -LiteralPath $versionPath -PathType Leaf)) { throw 'Missing client version.txt.' }
    $version = (Get-Content -LiteralPath $versionPath -TotalCount 1).Trim()
    if ($version -cne $manifest.versionFile) { throw "Wrong client version: $version. Required: $($manifest.version)." }
    if (-not (Test-Path -LiteralPath (Join-Path $Folder 'Albion-Online_BE.exe') -PathType Leaf)) {
        throw 'Missing Albion-Online_BE.exe.'
    }
}

try {
    if ((Test-Path -LiteralPath $clientPath) -and -not $CheckOnly) {
        Assert-ClientVersion $clientPath
        Write-Host 'Client already installed. Run 2-Mo-game.cmd.'
        exit 0
    }
    if (-not $CheckOnly) {
        $drive = [IO.DriveInfo]::new([IO.Path]::GetPathRoot($projectRoot))
        if ($drive.AvailableFreeSpace -lt 12GB) { throw 'At least 12 GB free space is needed for download and extraction.' }
    }
    if ([string]::IsNullOrWhiteSpace($ArchivePath)) {
        if ($CheckOnly) { throw '-CheckOnly requires -ArchivePath; it never downloads or installs.' }
        $downloadDir = Assert-ProjectPath (Join-Path $projectRoot 'downloads')
        [IO.Directory]::CreateDirectory($downloadDir) | Out-Null
        $ArchivePath = Join-Path $downloadDir ('albion-client-' + $manifest.version + '.zip')
        if (-not (Test-Path -LiteralPath $ArchivePath -PathType Leaf)) {
            $downloadUri = [Uri]$manifest.url
            if ($downloadUri.Scheme -cne 'https' -or $downloadUri.Host -cne 'live.albiononline.com') {
                throw 'Only the official HTTPS client source is allowed.'
            }
            $partialPath = Assert-ProjectPath ($ArchivePath + '.partial')
            Write-Host 'Downloading the official Windows client (about 3.14 GB). Please wait...'
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -UseBasicParsing -Uri $downloadUri -OutFile $partialPath -TimeoutSec 3600 -MaximumRedirection 0
            if ((Get-Item -LiteralPath $partialPath).Length -ne [long]$manifest.archiveBytes) {
                throw 'Downloaded size changed. Installation stopped; ask for a compatible client release.'
            }
            if ((Get-FileHash -LiteralPath $partialPath -Algorithm SHA256).Hash -ine $manifest.archiveSha256) {
                throw 'Downloaded SHA-256 does not match the approved client. Nothing was installed or run.'
            }
            $null = Assert-ProjectPath $ArchivePath
            Move-Item -LiteralPath $partialPath -Destination $ArchivePath
        }
    }
    $ArchivePath = (Resolve-Path -LiteralPath $ArchivePath).ProviderPath
    if ((Get-Item -LiteralPath $ArchivePath).Length -ne [long]$manifest.archiveBytes) { throw 'Archive size does not match the approved client.' }
    Write-Host 'Checking SHA-256 before extracting or running anything...'
    if ((Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash -ine $manifest.archiveSha256) {
        throw 'SHA-256 mismatch. Obtain the approved client; do not bypass this check.'
    }
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($ArchivePath)
    try {
        $versionEntry = $archive.GetEntry('version.txt')
        if ($null -eq $versionEntry -or $versionEntry.Length -gt 256) { throw 'Invalid archive version file.' }
        $reader = [IO.StreamReader]::new($versionEntry.Open())
        try { $archivedVersion = $reader.ReadToEnd().Trim() } finally { $reader.Dispose() }
        if ($archivedVersion -cne $manifest.versionFile) { throw 'Archive version does not match the server.' }
        if ($null -eq $archive.GetEntry('Albion-Online_BE.exe')) { throw 'Client executable missing from archive.' }
        foreach ($entry in $archive.Entries) {
            if ($entry.FullName -match '(^|[/\\])\.\.([/\\]|$)|^[\\/]|:') { throw 'Unsafe archive path.' }
        }
    } finally { $archive.Dispose() }
    if ($CheckOnly) {
        Write-Host "PASS approved archive SHA-256, version $($manifest.version), and safe archive paths. No files extracted."
        exit 0
    }
    $stagingPath = Assert-ProjectPath (Join-Path $projectRoot ('client-staging-' + [Guid]::NewGuid().ToString('N')))
    Write-Host 'Extracting client. This may take several minutes...'
    [IO.Compression.ZipFile]::ExtractToDirectory($ArchivePath, $stagingPath)
    Assert-ClientVersion $stagingPath
    $null = Assert-ProjectPath $stagingPath
    $null = Assert-ProjectPath $clientPath
    if (Test-Path -LiteralPath $clientPath) { throw 'Client directory appeared during installation; refusing to overwrite it.' }
    Move-Item -LiteralPath $stagingPath -Destination $clientPath
    $stagingPath = $null
    Write-Host 'Client ready. Run 2-Mo-game.cmd, then choose Create account inside the game.'
} catch {
    Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red
    if ($null -ne $stagingPath -and (Test-Path -LiteralPath $stagingPath)) {
        $safeStagingPath = Assert-ProjectPath $stagingPath
        if ([IO.Path]::GetFileName($safeStagingPath) -match '^client-staging-[a-f0-9]{32}$') {
            Remove-Item -LiteralPath $safeStagingPath -Recurse -Force
        }
    }
    exit 1
}
