param (
    [string]$inputPdf,
    [string]$outputImage,
    [int]$resolution = 300
)

# Check if the input PDF exists
if (-not (Test-Path $inputPdf)) {
    Write-Host "Input PDF file not found: $inputPdf"
    exit
}

# Command to convert PDF to image using ImageMagick's convert tool
$command = "magick -density $resolution `"$inputPdf`" `"$outputImage`""

# Run the command
Invoke-Expression $command

# Check if the conversion was successful
if (Test-Path $outputImage) {
    Write-Host "PDF successfully converted to image: $outputImage"
} else {
    Write-Host "Failed to convert PDF to image"
}