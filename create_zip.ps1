$destination = "C:\Users\Admin\Downloads\Devanshi\ResQNet_Project.zip"
$tempDir = "C:\Users\Admin\Downloads\Devanshi\temp_zip_staging"

if (Test-Path $destination) { Remove-Item -Force $destination }
if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }

New-Item -ItemType Directory -Path $tempDir | Out-Null

# Copy Backend excluding node_modules
Copy-Item -Path "C:\Users\Admin\Downloads\Devanshi\backend" -Destination $tempDir -Recurse
if (Test-Path "$tempDir\backend\node_modules") {
    Remove-Item -Recurse -Force "$tempDir\backend\node_modules"
}

# Copy Frontend excluding node_modules and dist
Copy-Item -Path "C:\Users\Admin\Downloads\Devanshi\frontend" -Destination $tempDir -Recurse
if (Test-Path "$tempDir\frontend\node_modules") {
    Remove-Item -Recurse -Force "$tempDir\frontend\node_modules"
}
if (Test-Path "$tempDir\frontend\dist") {
    Remove-Item -Recurse -Force "$tempDir\frontend\dist"
}

# Copy documentation, presentations, and scripts
Get-ChildItem -Path "C:\Users\Admin\Downloads\Devanshi" -Filter "*.md" | Copy-Item -Destination $tempDir
Get-ChildItem -Path "C:\Users\Admin\Downloads\Devanshi" -Filter "*.bat" | Copy-Item -Destination $tempDir
Get-ChildItem -Path "C:\Users\Admin\Downloads\Devanshi" -Filter "*.pdf" | Copy-Item -Destination $tempDir

# Compress to ZIP
Compress-Archive -Path "$tempDir\*" -DestinationPath $destination -CompressionLevel Optimal

# Cleanup
Remove-Item -Recurse -Force $tempDir

$zipItem = Get-Item $destination
Write-Output "ZIP_CREATED_SUCCESS: $($zipItem.FullName) ($([math]::Round($zipItem.Length / 1MB, 2)) MB)"
