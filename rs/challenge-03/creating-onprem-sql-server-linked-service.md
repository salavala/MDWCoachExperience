# Creating the On-premises SQL Server Linked Service to use the Self-Hosted Integration Runtime

As the previous Linked Services you created, based on
[this documentation](https://docs.microsoft.com/en-us/azure/data-factory/connector-sql-server#linked-service-properties),
create a file called `SQL-Server-LinkedService.json` with the following structure:

```json
{
    "name": "<filesystem linked service name>",
    "properties": {
        "type": "SqlServer",
        "typeProperties": {
            "connectionString": {
                "type": "SecureString",
                "value": "Data Source=<servername>\\<instance name if using named instance>;Initial Catalog=<databasename>;Integrated Security=False;User ID=<username>;Password=<password>;"
            }
        },
        "connectVia": {
            "referenceName": "<name of Integration Runtime>",
            "type": "IntegrationRuntimeReference"
        }
    }
}
```

> Note the double backslach on the `connectionString` value as it is a JSON file.
>
> Also note that the `<servername>` can be set as `localhost` as the
> Self-Hosted Integration Runtime agent is running on the machine itself.

Once you have the file created properly, run the PowerShell command below
to create the Linked Service on Data Factory:

```powershell
$resourceGroupName = "<resource group name>"
$dataFactoryName = "<data factory name>"
$linkedServiceName = "<sql server linked service name>"

Set-AzDataFactoryV2LinkedService `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $linkedServiceName `
    -File "./SQL-Server-LinkedService.json"
```