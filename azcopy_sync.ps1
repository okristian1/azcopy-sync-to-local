
# If the 'delete-destination' flag is set to true or prompt, then sync will delete files and blobs at the destination that are not present at the source.

# Set Variables
$StorageAccount = ""
$SasToken = ""   # Include '?' at the start if copied directly from Azure Portal
$LocalPath = "AzureSync"

# Construct the Blob Service URL
$BlobServiceUrl = "https://$StorageAccount.blob.core.windows.net"

# List all containers in the storage account
Write-Host "Fetching containers from: $BlobServiceUrl"

# Run AzCopy to list containers
$ContainerList = azcopy list "$BlobServiceUrl/$SasToken"

Write-Host $ContainerList

# Check if listing was successful
if ($ContainerList -match "failed to traverse") {
    Write-Host "Error: Failed to list containers. Check SAS token permissions."
    exit 1
}

# Display the container names
Write-Host "Found the following containers:"
$Containers = @()
$ContainerList | ForEach-Object {
    if ($_ -match '^([^/]+)/.*$') {
        $Containers += $matches[1]
        Write-Host $matches[1]
    }
}

# Loop through each container and sync its blobs
foreach ($ContainerName in $Containers) {
    Write-Host "`nProcessing container: $ContainerName"

    # Construct the Blob Container URL
    $BlobContainerUrl = "$BlobServiceUrl/$ContainerName"

    # Ensure the local directory for this container exists
    $ContainerLocalPath = "$LocalPath\$ContainerName"
    if (!(Test-Path -Path $ContainerLocalPath)) {
        Write-Host "Creating local directory: $ContainerLocalPath"
        New-Item -ItemType Directory -Path $ContainerLocalPath | Out-Null
    }

    # Sync blobs to the local folder
    Write-Host "Starting sync from $BlobContainerUrl to $ContainerLocalPath..."
    azcopy sync "$BlobContainerUrl$SasToken" "$LocalPath/$ContainerName" --recursive --delete-destination true
}

Write-Host "Sync complete!"
