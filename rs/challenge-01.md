# Challenge 01 - Define a data lake

## Requirements

For solving the challenges 1 to 3, you'll need to install the following tools:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Az PowerShell Module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.7.0)

## Creating ADLS Gen2

Use [this guide](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-quickstart-create-account#create-an-account-using-azure-cli)
to create a Storage Account with Azure Data Lake Storage Gen2.

```bash
# Create variables to have consistency throughout the tutorial
RESOURCE_GROUP="<resource group name>"
LOCATION="eastus"

# Install the storage-preview extension
az extension add --name storage-preview

# Create the Storage Account with ADLS Gen2 enabled
az storage account create \
  --name "<storage account name>" \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2 \
  --hierarchical-namespace true
```

## Learning experiences and road blocks

- Create and use the Azure Cloud Shell or
- Install the Azure CLI
- If people do not read, they won't realize that we need to install
the `storage-preview` extension to Azure CLI

## Potential feedbacks

- [This tutorial](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-quickstart-create-account#create-an-account-using-azure-cli)
is titled as *"Quickstart: Create an Azure Data Lake Storage
Gen2 storage account"*. To be more specific about ADLS Gen2 bein a **feature**
of a storage account, we could suggest it to be named as:

    > Quickstart: Create an Azure Storage Account with Data Lake Storage Gen2 enabled