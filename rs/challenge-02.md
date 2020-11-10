# Challenge 02 - Extract data from Azure SQL and Cosmos DB

This challenge asks you to copy data from

- The Azure SQL Databases
    - CloudSales
    - CloudStreaming
- The CosmosDB document collection
    - movies

To do that, we need to provision an extraction mechanism on Azure. This
detailed solution will cover this scenario using Azure Data Factory as the
extraction mechanism.

After you have the Data Factory provisioned, you will need to configure the
3 factory resources to be able to copy data from a source to a sink:

- Linked Service: this will declare where are you connecting to
- Dataset: will describe your data structure
- Pipeline: configures your data flow

## Create an Azure Data Factory

Azure Data Factory is a cloud data integration service to help you compose
data storage, movement, and processing services into automated data pipelines.

You can create an Azure Data Factory in two ways, like:

- Azure Portal
- Azure PowerShell

On this tutorial, you will create a Data Factory using **PowerShell**.

Detailed instructions can be found [here](https://docs.microsoft.com/en-us/azure/data-factory/quickstart-create-data-factory-powershell)

> If you are using another SO than Windows, you can leverage the Azure Cloud
> Shell to execute the commands below.

```powershell
# Create variables to have consistency throughout the tutorial
$resourceGroupName = "dryrunres"
$dataFactoryName = "<data factory name>"

# If you already have the Resource Group you will create the Data Factory in
$resourceGroup = Get-AzRmResourceGroup -Name $resourceGroupName

# If you will create the Resource Group as part of this tutorial
$resourceGroup = New-AzResourceGroup $resourceGroupName -location '<location>'

# Now to create the Data Factory
$DataFactory = Set-AzDataFactoryV2 `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $resourceGroup.Location -Name $dataFactoryName
```

## Copying SQL Data into Azure Data Lake Storage Gen2 using PowerShell

After we have the Storage Account with Data Lake Storage Gen2 enabled, we can
start configuring it for copying the data from the Databases into the data lake.

Follow the steps below in order to achieve it using PowerShell.

You will also need Linked Service configuration references for the different
Linked Service types you will create throughout this tutorial.
Have the [Dataset type](https://docs.microsoft.com/en-us/azure/data-factory/concepts-datasets-linked-services#dataset-type)
documentation in hand in case you want to check if the source or sink
you want to configure is supported and to check their samples.

- [01 - Creating the Linked Services](challenge-02/creating-linked-services.md)
    - Before creating datasets, we need linked services for connecting
    to data sources and sinks.
- [02 - Creating the Datasets](challenge-02/creating-datasets.md)
    - With Datasets, we define the data representations
    to be copied from or to.
- [03 - Creating the Pipelines](challenge-02/creating-pipelines.md)
    - These pipelines will orchestrate the Datasets
    to move data from the source to the sink.

## Learning experiences and road blocks

- If the attendee is using a MacOS and Azure CLI locally,
he/she won't be able to use bash to create the ADF. He/she will then
need to either
    - Use Azure Cloud Shell
    - Create the resource through the UI
- Uploading files through the Azure Cloud Shell

## Potential feedbacks

### Data Factory creation

- As far as I saw, there's no support for managing ADF
with Azure CLI.
- The menu on the left on [this link](https://docs.microsoft.com/en-us/azure/data-factory/#5-minute-quickstarts)
is showing wrong titles
    - For _"Create data factory"_, there should be only two:
        - User Interface (UI) or
        - Azure PowerShell
    - The others should be something like _"Create a pipeline - (subject)"_
- [This tutorial](https://docs.microsoft.com/en-us/azure/data-factory/quickstart-create-data-factory-powershell)
is not only to teach how to create an Azure Data Factory, but to create a
full **data movement** sample. It would be good to have a clear sample
about **Creating a Data Factory**.
    - This is because on this tutorial it first creates the Storage Account
    to hold the data that will be copied and then teaches how to create
    the Data Factory. So it may get confusing, people may create the Storage
    Account just because they're following the tutorial but they may actually
    not need it.

### Linked Services

- [This tutorial](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-bulk-copy)
does not share any reference for users to get other samples for different
linked service types, e.g., ADLS instead of SQL DW.
- The Azure Cloud Shell session expires too fast when running on a different
tab. It impacts if the user has set some variables to keep naming consistency
throughout the tutorial. These variables loose value if the session is dropped.

### Datasets

- I couldn't find a way to get CosmosDB connection strings
from a PowerShell command with the AzureRm module.
- On the Az PowerShell module, for creating Linked Services, we reference the
file using the `-File` parameter. For creating Datasets, the parameter with
a same purpose is named `-DefinitionFile`. We could have a standard here.
- Learning how Parquet files work
- The Dataset documentation is too weak in terms of techniques we can use to make the solution more robust, i.e., use of parameters.

### Pipelines

- When creating pipelines for CosmosDB as source, if copying data *as is*,
the parameter `properties:activities:<Copy Activity>:typeProperties:source:nestingSeparator`
**must** be blank. Otherwise, it will automatically assign "." as its value and
the pipeline won't work.