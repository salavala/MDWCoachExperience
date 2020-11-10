# Creating a Dataset for an on-premises SQL Server Database

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-sql-server#dataset-properties),
create a new JSON file named `SQL-Server-Dataset.json` with this structure:

```json
{
    "name": "<dataset name>",
    "properties": {
        "linkedServiceName": {
            "referenceName": "<On prem SQL Server Linked Service Name>",
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

Make sure to use the correct name for `<On prem SQL Server Linked Service Name>`.

Now use the commands below to create the Dataset on the Data Factory:

```powershell
$dataFactoryName = "<data factory name>"
$resourceGroupName = "<resource group name>"
$datasetName = "<dataset name>"

Set-AzDataFactoryV2Dataset `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $datasetName `
    -DefinitionFile ".\SQL-Server-Dataset.json"
```