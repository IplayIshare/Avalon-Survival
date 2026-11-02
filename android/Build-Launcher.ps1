param(
    [Parameter(Mandatory=$true)][string]$JdkPath,
    [Parameter(Mandatory=$true)][string]$BuildToolsPath,
    [Parameter(Mandatory=$true)][string]$AndroidJar,
    [Parameter(Mandatory=$true)][string]$KeyStorePath,
    [Parameter(Mandatory=$true)][string]$KeyPasswordFile,
    [string]$KeyAlias = 'albion-player',
    [string]$OutputDirectory = (Join-Path $PSScriptRoot '..\dist\android-launcher')
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Invoke-Checked([string]$Executable, [string[]]$Arguments) {
    & $Executable @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Build step failed: $Executable (exit $LASTEXITCODE)" }
}

foreach ($path in @($JdkPath, $BuildToolsPath, $AndroidJar, $KeyStorePath, $KeyPasswordFile)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Required path missing: $path" }
}
$taskOldJavaHome = $env:JAVA_HOME
$taskOldPath = $env:PATH
try {
    $env:JAVA_HOME = (Resolve-Path -LiteralPath $JdkPath).Path
    $env:PATH = (Join-Path $env:JAVA_HOME 'bin') + ';' + $env:PATH
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    $output = (Resolve-Path -LiteralPath $OutputDirectory).Path
    $work = Join-Path $output ('build-' + [Guid]::NewGuid().ToString('N'))
    $classes = New-Item -ItemType Directory -Path (Join-Path $work 'classes') -Force
    $dex = New-Item -ItemType Directory -Path (Join-Path $work 'dex') -Force
    $base = Join-Path $work 'base.apk'
    $aligned = Join-Path $work 'aligned.apk'
    $apk = Join-Path $output 'Albion-VPS-Android.apk'
    Invoke-Checked (Join-Path $BuildToolsPath 'aapt2.exe') @('link', '-I', $AndroidJar,
        '--manifest', (Join-Path $PSScriptRoot 'launcher\AndroidManifest.xml'), '-o', $base)
    $sources = @(Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'launcher\src') -Filter '*.java' -Recurse | ForEach-Object FullName)
    Invoke-Checked (Join-Path $JdkPath 'bin\javac.exe') (@('-encoding', 'UTF-8', '--release', '8',
        '-classpath', $AndroidJar, '-d', $classes.FullName) + $sources)
    $classFiles = @(Get-ChildItem -LiteralPath $classes.FullName -Filter '*.class' -Recurse | ForEach-Object FullName)
    Invoke-Checked (Join-Path $BuildToolsPath 'd8.bat') (@('--release', '--min-api', '25', '--lib', $AndroidJar,
        '--output', $dex.FullName) + $classFiles)
    Invoke-Checked (Join-Path $JdkPath 'bin\jar.exe') @('uf', $base, '-C', $dex.FullName, 'classes.dex')
    Invoke-Checked (Join-Path $BuildToolsPath 'zipalign.exe') @('-f', '4', $base, $aligned)
    Invoke-Checked (Join-Path $BuildToolsPath 'apksigner.bat') @('sign', '--ks', $KeyStorePath,
        '--ks-key-alias', $KeyAlias, '--ks-pass', "file:$KeyPasswordFile",
        '--out', $apk, $aligned)
    Invoke-Checked (Join-Path $BuildToolsPath 'apksigner.bat') @('verify', '--verbose', '--print-certs', $apk)
    $hash = (Get-FileHash -LiteralPath $apk -Algorithm SHA256).Hash.ToLowerInvariant()
    [IO.File]::WriteAllText((Join-Path $output 'SHA256SUMS.txt'), "$hash  Albion-VPS-Android.apk`n", [Text.Encoding]::ASCII)
    Write-Output "Built: $apk"
    Write-Output "SHA-256: $hash"
} finally {
    $env:JAVA_HOME = $taskOldJavaHome
    $env:PATH = $taskOldPath
}
