# Creating the Datasets on Data Factory

When creating a Dataset, you define a dataset that represents the data to
copy from or to. Every Dataset is associated with a Linked Service,
which we created on the previous step.

## 01 - Create the Dataset for the CloudSales

> For naming datasets, you can only use letters, numbers and '_'.

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/quickstart-create-data-factory-powershell#create-a-dataset),
create a new JSON file named `CloudSales-Dataset.json` with this structure:

```json
{
    "name": "<dataset name>",
    "properties": {
        "linkedServiceName": {
            "referenceName": "<CloudSales Linked Service Name>",
            "type": "LinkedServiceReference"
        },
        "parameters": {
            "tableName": {
                "type": "String"
            }
        },
        "type": "AzureSqlTable",
        "typeProperties": {
            "tableName": {
                "value": "@dataset().tableName",
                "type": "Expression"
            }
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
```

Make sure to use the correct name for `<CloudSales Linked Service Name>`.
Also make sure to name your dataset properly, e.g., `CloudSales_SQL`.

Now use the commands below to create the Dataset on the Data Factory:

```powershell
$dataFactoryName = "<data factory name>"
$resourceGroupName = "<resource group name>"
$datasetName = "<dataset name>"

Set-AzDataFactoryV2Dataset `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $datasetName `
    -DefinitionFile ".\CloudSales-Dataset.json"
```

## 02 - Create the Dataset for the CloudStreaming

Repeat the steps above to create a Dataset for the CloudStreaming database.
The things you need to make sure that are different are:

- `linkedService:ReferenceName` on the JSON definition file for the Dataset
- `name` for the Dataset on the JSON definition file
- `<dataset name>` on the PowerShell script to create the Dataset (which needs)
to be the same name you used on the JSON definition file

## 03 - Create the Dataset for the Movies catalog on CosmosDB

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-cosmos-db#dataset-properties),
you will create a Dataset to define the data format for the Movies database
on Cosmos DB.

Create a new JSON file called `Movies-Dataset.json` with the following structure:

```json
{
    "name": "<dataset name>",
    "properties": {
        "type": "DocumentDbCollection",
        "linkedServiceName":{
            "referenceName": "<Movies Linked Service Name>",
            "type": "LinkedServiceReference"
        },
        "typeProperties": {
            "collectionName": "<collection name>"
        }
    }
}
```

Make sure to use the correct name for `<Movies Linked Service Name>`.
Also, remember to replace `<collection name>` with the name of the CosmosDB
database collection you will ingest using this process. On this sample, you
will use `movies`.

Now use the commands below to create the Dataset on the Data Factory:

```powershell
$dataFactoryName = "<data factory name>"
$resourceGroupName = "<resource group name>"
$datasetName = "<dataset name>"

Set-AzDataFactoryV2Dataset `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $datasetName `
    -DefinitionFile ".\Movies-Dataset.json"
```

## 04 - Create the Sink Dataset for Azure SQL Database tables

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-data-lake-storage#dataset-properties),
you will create a Dataset to describe the data format for Azure Data Lake
Storage Gen2 as a sink for parquet files. This dataset will be used for copying the Azure SQL
Database tables.

> For the Southridge case, which copies data from Azure SQL, we can copy
> the data as a Parquet already, what will make it easier to load it
> for transformation purposes later.

Create a new JSON file called `ADLS-Dataset-Parquet.json` with the following structure:

```json
{
    "name": "<dataset name>",
    "properties": {
        "linkedServiceName": {
            "referenceName": "<ADLS Linked Service name>",
            "type": "LinkedServiceReference"
        },
        "parameters": {
            "tableName": {
                "type": "String"
            },
            "filePath": {
                "type": "string"
            }
        },
        "type": "AzureBlobFSFile",
        "typeProperties": {
            "format": {
                "type": "ParquetFormat"
            },
            "fileName": {
                "value": "@{concat(dataset().tableName, '.parquet')}",
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

Make sure to use the correct linked service name to replace
`<ADLS Linked Service name>`.

- `@dataset().filePath` will serve to define the folder structure the
pipeline will save the file.
- `@dataset().tableName` will receive the table name so it can save a
parquet file for it.

Now use the commands below to create the Dataset on Data Factory:

```powershell
$dataFactoryName = "<data factory name>"
$resourceGroupName = "<resource group name>"
$datasetName = "<dataset name>"

Set-AzDataFactoryV2Dataset `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $datasetName `
    -DefinitionFile ".\ADLS-Dataset-Parquet.json"
```

## 05 - Create the Sink Dataset for the Movies catalog

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-data-lake-storage#dataset-properties),
you will create a Dataset to describe the data format for Azure Data Lake
Storage Gen2 as a sink for JSON files.

Create a new JSON file called `ADLS-Dataset-JSON.json` with the following structure:

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
            "format": {
                "type": "JsonFormat",
                "filePattern": "arrayOfObjects"
            },
            "fileName": {
                "value": "@{concat(dataset().fileName, '.json')}",
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

Make sure to use the correct name for `<CloudSales Linked Service Name>`.
Also make sure to name your dataset properly, e.g., `ADLS_CloudSales_JSON`.

Now use the commands below to create the Dataset on the Data Factory:

```powershell
$dataFactoryName = "<data factory name>"
$resourceGroupName = "<resource group name>"
$datasetName = "<dataset name>"

Set-AzDataFactoryV2Dataset `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $datasetName `
    -DefinitionFile ".\ADLS-Dataset-JSON.json"
```