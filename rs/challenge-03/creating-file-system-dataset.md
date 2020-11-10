# Creating a Dataset for File System sources

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-file-system#dataset-properties),
you will create a Dataset for the File System source.

Create a new JSON file and name it `File-System-Dataset.json` with the following structure:

```json
{
    "name": "<file system dataset name>",
    "properties": {
        "type": "FileShare",
        "linkedServiceName":{
            "referenceName": "<file system linked service name>",
            "type": "LinkedServiceReference"
        },
        "parameters": {
            "fileName": {
                "type": "String"
            }
        },
        "typeProperties": {
            "folderPath": "<folder/subfolder/ you will copy data from>",
            "fileName": "@dataset().fileName",
            "modifiedDatetimeStart": "2018-12-01T05:00:00Z",
            "modifiedDatetimeEnd": "2020-12-01T06:00:00Z",
            "format": {
                "type": "TextFormat",
                "columnDelimiter": ",",
                "rowDelimiter": "\n",
                "firstRowAsHeader": true
            }
        }
    }
}
```

> Note that `properties:typeProperties:folderPath` is relative to the root
> path you configured on the
> [File System Linked Service](creating-file-system-linked-service.md).
> If you will copy files from the folder specified on the Linked Service,
> use "." as a value for this property.
>
> Also, make sure that the files on the on-premises virtual machine have the
> `modifiedDate` property between
> `properties:typeproperties:modifiedDatetimeStart` and
> `properties:typeproperties:modifiedDatetimeEnd`.

Once you created the file, use the following PowerShell command to create
the Dataset on Azure Data Factory:

```powershell
$dataFactoryName = "<data factory name>"
$resourceGroupName = "<resource group name>"
$datasetName = "<dataset name>"

Set-AzDataFactoryV2Dataset `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $datasetName `
    -DefinitionFile ".\File-System-Dataset.json"
```