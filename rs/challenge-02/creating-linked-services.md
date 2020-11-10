# Creating the Linked Services for Azure Data Factory

## 01 - Configure Linked Services for Azure SQL databases

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-sql-database#linked-service-properties),
you will create a Data Factory Linked Service for having an Azure SQL as a data source.

Create a new JSON file named `CloudSales-LinkedService.json` with the following structure:

```json
{
    "name": "<Name for the Linked Service>",
    "properties": {
        "type": "AzureSqlDatabase",
        "typeProperties": {
            "connectionString": {
                "type": "SecureString",
                "value": "Server=tcp:<servername>.database.windows.net,1433;Database=<databasename>;User ID=<username>@<servername>;Password=<password>;Trusted_Connection=False;Encrypt=True;Connection Timeout=30"
            }
        }
    }
}
```

Attentions to the value you need to replace:

- `<Name for the Linked Service>`
- SQL Server `<servername>`
- SQL `<databasename>`
- SQL Server `<username>`
- SQL SQL Server `<password>`

Run the commands below using PowerShell to create this Linked Service:

> If you're running these commands on the Azure Cloud Shell, make sure
> upload the JSON file before proceeding, as well as taking note of
> the file location.

```powershell
# Creating the values to avoid typing errors
$resourceGroupName = "<resource group name>"
$dataFactoryName = "<data factory name>"
$linkedServiceName = "<cloud sales linked service name>"

Set-AzDataFactoryV2LinkedService `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $linkedServiceName `
    -File "./CloudSales-LinkedService.json"
```

For the Cloud Streaming database, you can duplicate the JSON file you created
before, changing just the properties to point to the correct database as well
as creating a different Linked Service name. So take care of updating
the following properties:

- The file name (e.g., `CloudStreaming-LinkedService.json`)
- `<Name for the Linked Service>`
- `<databasename>`

> Other properties do not need to be updated strictly because both databases
> are on a same server. In a real-life scenario, different servers and
> credentials are more likely.

The command for creating the Cloud Streaming Linked Service should then be:

```powershell
# Reassigning the linkedServiceName variable
$linkedServiceName = "<cloud streaming linked service name>"

Set-AzDataFactoryV2LinkedService `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $linkedServiceName `
    -File "./CloudStreaming-LinkedService.json"
```

## 02 - Configure a Linked Service for the Cosmos DB as a source

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-cosmos-db#linked-service-properties),
you will create a linked Service to have the Cosmos DB as a data source.

First, you need to obtain the CosmosDB full `connectionString` from Azure.
To do so, use the following Azure CLI command:

```powershell
$resourceGroupName = "<resource group name>"
$cosmosDbAccountName = "<the CosmosDB account name>"

az cosmosdb list-connection-strings \
    -n $cosmosDbAccountName
    -g $resourceGroupName
```

> This action is currently not supported on Az Module.

You will have an output similar to the following:

```json
{
  "connectionStrings": [
    {
      "connectionString": "AccountEndpoint=https://<cosmosdb name>.documents.azure.com:443/;AccountKey=<account key1>",
      "description": "Primary SQL Connection String"
    },
    {
      "connectionString": "AccountEndpoint=https://<cosmosdb name>.documents.azure.com:443/;AccountKey=<account key2>",
      "description": "Secondary SQL Connection String"
    },
    {
      "connectionString": "AccountEndpoint=https://<cosmosdb name>.documents.azure.com:443/;AccountKey=<read-only account key1>",
      "description": "Primary Read-Only SQL Connection String"
    },
    {
      "connectionString": "AccountEndpoint=https://<cosmosdb name>.documents.azure.com:443/;AccountKey=<read-only account key2>",
      "description": "Secondary Read-Only SQL Connection String"
    }
  ]
}
```

> As the CosmosDB is going to be used as a Data Source, it is recommended to use
> one of the `Read-Only SQL Connection String` connection strings.

As you will notice, none of the connection strings specify the `Database`
by the end of the string, so make sure to keep it and also specify
the database you want to extract data from.

> You can get a list of *database names* from Cosmos DB Data Explorer on
> Azure Portal. To get it using Azure CLI, use the following command:

```cmd
az cosmosdb database list \
-n <Azure Cosmos DB account name> \
-g `<resource group name>`
```

> For the scope of this sample, you will have only one database.
> In case you have more than one, just select one of them and then use the
> value from the `id` field as your database name.

Now that you have all the data from the CosmosDB data source,
create a new JSON file named `Movies-LinkedService.json` with the following structure:

```json
{
    "name": "<Name for the Movies Linked Service>",
    "properties": {
        "type": "CosmosDb",
        "typeProperties": {
            "connectionString": {
                "type": "SecureString",
                "value": "AccountEndpoint=<EndpointUrl>;AccountKey=<AccessKey>;Database=<Database>"
            }
        }
    }
}
```

Now use the command below to create the CosmosDB Linked Service:

```powershell
# Reassigning the linkedServiceName variable
$linkedServiceName = "<Name for the Movies Linked Service>"

Set-AzDataFactoryV2LinkedService `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $linkedServiceName `
    -File "./Movies-LinkedService.json"
```

## 03 - Configure a Linked Service for the Data Lake as a sink

Using [this reference](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-data-lake-storage#linked-service-properties)
you will create a Linked Service to have the Data Lake you created previously
as a sink for the pipeline.

First, you will need the Storage Account's Key to let Data Factory read from
and write to the ADLS Gen2. To do it, you will obtain the `accountKey` for
the ADLS Gen2 using the command below:

```powershell
Get-AzStorageAccountAccountKey `
    -ResourceGroupName $resourceGroupName `
    -Name "<storage account name>"
```

You will notice a result like below:

```powershell
KeyName Value               Permissions
------- -----               -----------
key1    <key1 value>        Full
key2    <key2 value>        Full
```

Use either `<key1 value>` or `<key2 value>` on your JSON file as your `<accountkey>`.

Now that you have the `accountKey`, create a new JSON file named
`ADLS-LinkedService.json` with the following structure:

```json
{
    "name": "<Name for the Data Lake Linked Service>",
    "properties": {
        "type": "AzureBlobFS",
        "typeProperties": {
            "url": "https://<accountname>.dfs.core.windows.net",
            "accountkey": {
                "type": "SecureString",
                "value": "<accountkey>"
            }
        }
    }
}
```

Now use the command below to create the Data Lake Gen2 Linked Service:

```powershell
# Reassigning the linkedServiceName variable
$linkedServiceName = "<Name for the Data Lake Linked Service>"

Set-AzDataFactoryV2LinkedService `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $linkedServiceName `
    -File "./ADLS-LinkedService.json"
```