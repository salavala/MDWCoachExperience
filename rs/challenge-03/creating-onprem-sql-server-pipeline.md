# Creating the Pipeline to copy data from on-prem SQL to ADLS

Using the references below:

- [Pipeline JSON reference](https://docs.microsoft.com/en-us/azure/data-factory/concepts-pipelines-activities#pipeline-json)
- [ForEach activity in Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/control-flow-for-each-activity)
- [Copy activity properties for SQL Server](https://docs.microsoft.com/en-us/azure/data-factory/connector-sql-server#copy-activity-properties)

You will create a new Pipeline to copy data from the on-premises SQL Server
database to the Azure Data Lake.

Create a new JSON file named `SQL-Server-Pipeline.json` with the following structure:

```json
{
    "name": "<pipeline name>",
    "properties": {
        "activities": [
            {
                "name": "ForEach_Table",
                "type": "ForEach",
                "typeProperties": {
                    "items": {
                        "value": "@pipeline().parameters.items",
                        "type": "Expression"
                    },
                    "activities": [
                        {
                            "name": "Copy_Rows",
                            "type": "Copy",
                            "policy": {
                                "timeout": "7.00:00:00",
                                "retry": 0,
                                "retryIntervalInSeconds": 30,
                                "secureOutput": false,
                                "secureInput": false
                            },
                            "userProperties": [
                                {
                                    "name": "Source",
                                    "value": "@{item().source.tableName}"
                                },
                                {
                                    "name": "Destination",
                                    "value": "@{pipeline().parameters.destinationFolder}/@{item().destination.fileName}"
                                }
                            ],
                            "typeProperties": {
                                "source": {
                                    "type": "SqlSource"
                                },
                                "sink": {
                                    "type": "AzureBlobFSSink"
                                },
                                "enableStaging": false
                            },
                            "inputs": [
                                {
                                    "referenceName": "<source dataset name>",
                                    "type": "DatasetReference",
                                    "parameters": {
                                        "tableName": "@item().source.tableName"
                                    }
                                }
                            ],
                            "outputs": [
                                {
                                    "referenceName": "<sink dataset name>",
                                    "type": "DatasetReference",
                                    "parameters": {
                                        "fileName": "@item().destination.fileName",
                                        "filePath": "@pipeline().parameters.destinationFolder"
                                    }
                                }
                            ]
                        }
                    ]
                }
            }
        ],
        "parameters": {
            "items": {
                "type": "Array",
                "defaultValue": [
                    {
                        "source": {
                            "tableName": "[dbo].[Table1]"
                        },
                        "destination": {
                            "fileName": "Table1"
                        }
                    },
                    {
                        "source": {
                            "tableName": "[dbo].[Table2]"
                        },
                        "destination": {
                            "fileName": "Table2"
                        }
                    },
                    {
                        "source": {
                            "tableName": "[dbo].[TableN]"
                        },
                        "destination": {
                            "fileName": "TableN"
                        }
                    }
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
- `<sink dataset name>`: the name of the destination dataset (JSON)
- `parameters:items`: is the list of tables you will copy to the sink.
You will notice table names like `[dbo].[Table1]`. Replace it with the names
of the tables you will copy and add new ites as needed.
- `destinationFolder:defaultValue`: replace `<folder name>` with the name of
the folder you want to store the VanArsdel files.

> Also about `parameters:items`, this pipeline leverages on a very important
> instruction: `ForEach`. **ForEach** is a loop instruction that will repeat one
> or more activives - in this case, the `Copy_Rows` - over every given item.
>
> For more information about the `ForEach` activity, refer to
> [this link](https://docs.microsoft.com/en-us/azure/data-factory/control-flow-for-each-activity).

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
    -DefinitionFile ".\SQL-Server-Pipeline.json"
```