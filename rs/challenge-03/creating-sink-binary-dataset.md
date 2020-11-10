# Creating a Binary dataset for sink

You may encounter situations where you want to copy files from the source
*as is*. For example, you have an on-premises machine with CSV files and
you don't have the necessary requirements in place to generate
[parquet](https://docs.microsoft.com/en-us/azure/data-factory/supported-file-formats-and-compression-codecs#parquet-format)
files. You can copy these CSV files *as is* for further processing.

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-data-lake-storage#dataset-properties),
you will create a Dataset to describe the data format for Azure Data Lake
Storage Gen2 as a sink.

Create a new JSON file called `ADLS-Dataset-Binary.json` with the following structure:

```json
{
    "name": "<dataset name>",
    "properties": {
        "linkedServiceName": {
            "referenceName": "<ADLS Linked Service name>",
            "type": "LinkedServiceReference"
        },
        "parameters": {
            "fileName": {
                "type": "String"
            },
            "filePath": {
                "type": "string"
            }
        },
        "type": "AzureBlobFSFile",
        "typeProperties": {
            "fileName": {
                "value": "@dataset().fileName",
                "type": "Expression"
            },
            "folderPath": {
                "value": "@dataset().filePath",
                "type": "Expression"
            }
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
```

Make sure to use the correct name for `<ADLS Linked Service name>`.
Also make sure to name your dataset properly, e.g., `FourthCoffee_ADLS_Binary`.

Now use the commands below to create the Dataset on the Data Factory:

```powershell
$dataFactoryName = "<data factory name>"
$resourceGroupName = "<resource group name>"
$datasetName = "<dataset name>"

Set-AzDataFactoryV2Dataset `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $datasetName `
    -DefinitionFile ".\ADLS-Dataset-Binary.json"