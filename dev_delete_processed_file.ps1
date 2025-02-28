
# Define variables
$storageAccount = ""
$containerName = "<your-container>"
#$blobName = "<your-blob-name>"
$sasToken = "" # Ensure this has delete permissions
#$staticFolderName="SLK-45"
$BaseUrl = "https://${StorageAccount}.blob.core.windows.net"

# Set the root folder containing subfolders named after Azure Blob containers
$LocalFolder = "ProcessedData"  # Stop at ProcessedData

# Get all files in the local folder recursively
$Files = Get-ChildItem -Path $LocalFolder -Recurse | Where-Object { -not $_.PSIsContainer }
Write-Output "Files found: $($Files.Count)"
Write-Output ""

foreach ($File in $Files) {
    # Get the relative path by removing everything up to "ProcessedData"
    $TrimmedPath = $File.FullName -replace ".*?/ProcessedData", ""
    
    # Ensure the path uses forward slashes
    $TrimmedPath = $TrimmedPath -replace '\\', '/'

    # Construct the full delete URL
    $DeleteURL = "$BaseUrl$TrimmedPath$SasToken"

    # Display what will be deleted
    Write-Output "Deleting: $DeleteURL"

    # Run azcopy rm with the correct URL
    azcopy rm $DeleteURL --recursive=true
}

Write-Output "Script execution completed."