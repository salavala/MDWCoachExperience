# Creating the Pipeline to copy data from on-prem SQL to ADLS

Using the references below:

- [Pipeline JSON reference](https://docs.microsoft.com/en-us/azure/data-factory/concepts-pipelines-activities#pipeline-json)
- [ForEach activity in Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/control-flow-for-each-activity)
- [Copy Activity properties](https://docs.microsoft.com/en-us/azure/data-factory/connector-file-system#copy-activity-properties)

You will create a new Pipeline to copy data from the on-premises File System
to the Azure Data Lake.

Create a new JSON file named `File-System-Pipeline.json` with the following structure:


```json
{
    "name": "<pipeline name>",
    "properties": {
        "activities":[
            {
                "name": "ForEach_File",
                "type": "ForEach",
                "typeProperties": {
                    "isSequential": "true",
                    "items": {
                        "value": "@pipeline().parameters.files",
                        "type": "Expression"
                    },
                    "activities": [
                        {
                            "name": "CopyFromFileSystem",
                            "type": "Copy",
                            "inputs": [
                                {
                                    "referenceName": "<source dataset name>",
                                    "type": "DatasetReference",
                                    "parameters": {
                                        "fileName": "@item()"
                                    }
                                }
                            ],
                            "outputs": [
                                {
                                    "referenceName": "<sink dataset name>",
                                    "type": "DatasetReference",
                                    "parameters": {
                                        "fileName": "@item()",
                                        "filePath": "@pipeline().parameters.destinationFolder"
                                    }
                                }
                            ],
                            "typeProperties": {
                                "source": {
                                    "type": "FileSystemSource",
                                    "recursive": true
                                },
                                "sink": {
                                    "type": "AzureBlobFSSink"
                                }
                            }
                        }
                    ]
                }
            }
        ],
        "parameters": {
            "files": {
                "type": "Array",
                "defaultValue": [
                    "file1.ext",
                    "file2.ext",
                    "file3.ext",
                    "fileN.ext"
                ]
            },
            "destinationFolder": {
                "type": "String",
                "defaultValue": "<folder name>"
            }
        }
    },
    "type": "Microsoft.DataFactory/factories/pipelines"
}
```

Attention to replace the following values:

- `<pipeline name>`: a name for your pipeline
- `<source dataset name>`: the name of the source dataset
- `<sink dataset name>`: the name of the destination dataset (binary)
- `parameters:files`: is the list of files you will copy to the sink.
You will notice file names like `fileN.ext`. Replace it with the names
of the files and their extensions you will copy and add new ites as needed.
- `destinationFolder:defaultValue`: replace `<folder name>` with the name of
the folder you want to store the FourthCoffee files.

Once you have the file adjusted properly, run the PowerShell commands below
to create the pipeline on Data Factory:

```powershell
$dataFactoryName = "<data factory name>"
$resourceGroupName = "<resource group name>"
$pipelineName = "<pipeline name>"

Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $pipelineName `
    -DefinitionFile ".\File-System-Pipeline.json"
```