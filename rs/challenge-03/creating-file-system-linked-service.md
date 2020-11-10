# Creating the File System Linked Service to use the Self-Hosted Integration Runtime

As the previous Linked Services you created, based on
[this documentation](https://docs.microsoft.com/en-us/azure/data-factory/connector-file-system#linked-service-properties),
create a file called `FileSystem-LinkedService.json` with the following structure:

```json
{
    "name": "<filesystem linked service name>",
    "properties": {
        "type": "FileServer",
        "typeProperties": {
            "host": "<host>",
            "userid": "<domain>\\<user>",
            "password": {
                "type": "SecureString",
                "value": "<password>"
            }
        },
        "connectVia": {
            "referenceName": "<name of Integration Runtime>",
            "type": "IntegrationRuntimeReference"
        }
    }
}
```

Notice that `<host>` here **is not** the virtual machine host name. You
should specify the root folder you want to serve and share through
this Linked Service, e.g., `C:\\Rentals`.

Make sure to also replace `<domain>\\<user>`, `<password>` and
`<name of Integration Runtime>` with proper values.

> Also note the double backslach as it is a JSON file.
>
> Avoid exposing the whole C: drive as a Linked Service to prevent security
> breaches. Instead, create different Linked Services for each drive subfolder
> you have on the on-premises machine.

Once you have the file created properly, run the PowerShell command below
to create the Linked Service on Data Factory:

```powershell
# Creating the values to avoid typing errors
$resourceGroupName = "<resource group name>"
$dataFactoryName = "<data factory name>"
$linkedServiceName = "<filesystem linked service name>"

Set-AzDataFactoryV2LinkedService `
    -DataFactoryName $dataFactoryName `
    -ResourceGroupName $resourceGroupName `
    -Name $linkedServiceName `
    -File "./FileSystem-LinkedService.json"
```