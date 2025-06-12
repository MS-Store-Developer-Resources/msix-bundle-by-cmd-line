# Stop on first error
$ErrorActionPreference = "Stop"

# Define architectures
$architectures = @("x86", "x64", "arm64")

# Paths
$rootFolder = "bin"
$outputFolder = "Packages"
$appName = "7zip"
$bundlePath = Join-Path $outputFolder "$appName.msixbundle"

# Create output directory if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# Clean previous MSIXs and bundles
Get-ChildItem -Path $outputFolder -Include *.msix,*.msixbundle -Force -Recurse | Remove-Item -Force

# Build MSIX packages
foreach ($arch in $architectures) {
    $inputDir = Join-Path $rootFolder $arch
    $outputMsix = Join-Path $outputFolder "$appName_$arch.msix"

    Write-Host "📦 Packing $arch..."
    MakeAppx pack /d $inputDir /p $outputMsix
}

# Create MSIX bundle
Write-Host "📦 Creating bundle..."
MakeAppx bundle /v /d $outputFolder /p $bundlePath

Write-Host "`n✅ All MSIX packages and bundle built successfully!"
