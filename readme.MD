README

This is a description of the following two powershell scripts: 
- dev_azcopy_sync.ps1 
- dev_delete_processed_file.ps1

##  dev_azcopy_sync.ps1 
This script connects to an azure storage container and uses azcopy to download all files and folders that exist in the storage container.
They will be stored as they are in azure where the name of the container is the name of the first folder. They are stored in a folder named AzureSync
```
├── AzureSync
│   ├── nycontainer
│   │   ├── SLK-45
│   │   │   ├── testfil1
│   │   │   └── testfil2
│   │   └── test45
│   │       ├── testfil1
│   │       └── testfil2

```
## dev_delete_processed_file.ps1
This script checks a folder named ProcessedData. The folder should be created manually and pointed to from the script.

### If there is a file in a folder under the ProcessedData folder it takes it to mean that the file is processed and should be deleted from Azure.

The file is not deleted locally by the script, only in Azure.

That means that if the folders and files are copied or moved from AzureSync to ProcessedData and the script is ran the 4 example files will be deleted. Folders are left alone for reuse.
```
├── ProcessedData
│   ├── nycontainer
│   │   ├── SLK-45
│   │   │   ├── testfil1
│   │   │   └── testfil2
│   │   └── test45
│   │       ├── testfil1
│   │       └── testfil2
```


Only files that exist in ProcessedData are marked for deletion. So if the file structure in AzureSync is this:

```
├── AzureSync
│   ├── nycontainer
│   │   ├── SLK-45
│   │   │   ├── testfil1
│   │   │   └── testfil2
│   │   └── test45
│   │       ├── testfil1
│   │       └── testfil2
'
```
And ProcessedData only contains this:
```
├── ProcessedData
│   ├── nycontainer
│   │   ├── SLK-45
│   │   │   ├── testfil1
│   │   │   └── testfil2
```

Then these files will not be touched
```
├── AzureSync
│   ├── nycontainer
│   │   └── test45
│   │       ├── testfil1
│   │       └── testfil2
```
While these files ( not the folders ) would be deleted.
```
├── AzureSync
│   ├── nycontainer
│   │   ├── SLK-45
│   │   │   ├── testfil1
│   │   │   └── testfil2
```