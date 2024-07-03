
& "$PSScriptRoot\LoadZipContentInToMemory.ps1"

Write-Host "Load zip file in memory"
$zip = Load-ZipContentInToMemory -ZipFile .\testzip.zip
$zip

Write-Host
Write-Host "Load zip file in memory with recursely, this will load zip files in a zip file"
Write-Host
$ziprecursely = Load-ZipContentInToMemory -ZipFile .\testzip.zip -Recurse
$ziprecursely
