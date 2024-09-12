param(
    [Parameter(Mandatory=$true)][string]$inputPdfPath,
    [Parameter(Mandatory=$true)][string]$outputFolderPath
)

# Check if pdftk is installed
$pdftk = Get-Command pdftk -ErrorAction SilentlyContinue
if (-not $pdftk) {
    Write-Error "pdftk is not installed or not found in the system path. Please install pdftk."
    return
}

# Create output directory if it doesn't exist
if (-not (Test-Path $outputFolderPath)) {
    New-Item -ItemType Directory -Path $outputFolderPath
}

# Generate the command to split the PDF
$outputPattern = Join-Path $outputFolderPath "page_%d.pdf"
$command = "pdftk $inputPdfPath burst output $outputPattern"

# Run the pdftk command
Invoke-Expression $command

Write-Host "PDF split completed. Pages saved in $outputFolderPath"