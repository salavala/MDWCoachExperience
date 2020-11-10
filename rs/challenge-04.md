# Challenge 04 - Transforming all the data

The goal for this challenge is to merge all the common data and also
to adjust some data types, all of it following one source control
branch best practice.

To pass this challenge, this detailed solution will cover the Databricks option.

## Protecting the master branch with Pull Request policies

The objective is to prevent commits and pushes to be done directly to master.
This will prevent unapproved code to be automatically deployed to environments
in the future. For now, the idea is to turn the `master` branch into a codebase
for stable code.

To do it, there's a very good guide available as a Microsoft docs
[here](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops).
More specifically,
[this step](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops#require-a-minimum-number-of-reviewers)
will help you having at least one reviewer if anyone wants
to send code to master.

## Creating the Databricks workspace

Using [this reference](https://azure.microsoft.com/en-us/resources/templates/101-databricks-workspace/),
you will create a new Databricks workspace with the following properties:

- `workspaceName`: the name for your workspace
- `pricingTier`: Standard, for the scope of this solution

### Azure CLI

```cmd
RESOURCE_GROUP_NAME="<Name of the resource group you already have>"
WORKSPACE_NAME="<The name for your Databricks workspace>"
PRICING_TIER="standard"
TEMPLATE_URI="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-databricks-workspace/azuredeploy.json"

az group deployment create \
    --resource-group $RESOURCE_GROUP_NAME \
    --template-uri $TEMPLATE_URI
    --parameters \
    workspaceName=$WORKSPACE_NAME \
    pricingTier=$PRICING_TIER
```

### PowerShell

> **Warning**: For the scope of this guidance, we strongly recommend you to
> use Azure CLI. PowerShell Az module does not allow you to retrieve the plain
> text Service Principal's password, which you will need later in this scenario

```powershell
$resourceGroupName = "<Name of the resource group you already have>"
$workspaceName = "<The name for your Databricks workspace>"
$pricingTier = "standard"
$templateUri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-databricks-workspace/azuredeploy.json"

New-AzResourceGroupDeployment `
    -TemplateUri $templateUri
    -ResourceGroupName $resourceGroupName `
    -workspaceName $workspaceName `
    -pricingTier $pricingTier
```

## Create a Service Principal

You will use a Service Principal to let Databricks access the Data Lake Storage
on the Azure Storage Account. To do so, follow the steps below:

References:

- [Tutorial: Access Data Lake Storage Gen2 data with Azure Databricks using Spark](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-use-databricks-spark)
- [Manage access to Azure resources using RBAC and Azure PowerShell](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-powershell)
- [Grant access to Azure blob and queue data with RBAC in the Azure portal](https://docs.microsoft.com/en-us/azure/storage/common/storage-auth-aad-rbac-portal#assign-rbac-roles-using-the-azure-portal)
- [Grant access to Azure blob and queue data with RBAC using **PowerShell**](https://docs.microsoft.com/en-us/azure/storage/common/storage-auth-aad-rbac-powershell#list-available-rbac-roles)

You can do it with a single command:

- The creation of a new Service Principal
- The assignment of the `Storage Blob Data Contributor` to this Service
Principal on the Storage Account

### PowerShell

```powershell
$spDisplayName = "<The display name for the Service Principal>"
$scope = "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.Storage/storageAccounts/<storage account name>"

New-AzADServicePrincipal `
    -DisplayName riserradsp `
    -Role "Storage Blob Data Contributor" `
    -Scope $scope
```

Make sure to fill in the following placeholders:

- `<subscription id>`
- `<resource group name>`
- `<storage account name>`

You will have an output similar to this:

```powershell
Secret                : System.Security.SecureString
ServicePrincipalNames : {<ApplicationId GUID>, http://<Service Principal Display Name>}
ApplicationId         : <ApplicationId GUID>
ObjectType            : ServicePrincipal
DisplayName           : <Service Principal Display Name>
Id                    : <Service Principal Object Id>
Type                  :
```

### Azure CLI

```bash
$SP_DISPLAYNAME="<The display name for the Service Principal>"
$SCOPE="/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.Storage/storageAccounts/<storage account name>"

az ad sp create-for-rbac \
    -n $SP_DISPLAYNAME \
    --role "Storage Blob Data Contributor" \
    --scope $SCOPE
```

And the output should be:

```bash
{
  "appId": "<ApplicationID GUID>",
  "displayName": "<Service Principal Display Name>",
  "name": "http://<Service Principal Display Name>",
  "password": "<Service Principal Password/Secret GUID>",
  "tenant": "<Tenant ID>"
}
```

## Install the Databricks CLI

Using
[this reference](https://github.com/databricks/databricks-cli#installation),
you will install the Databricks CLI using `pip`. The requirement here is:

- Python 2.7.9+ or 3.6

```bash
pip install --upgrade databricks-cli
```

If you receive a message like below:

```bash
Cannot uninstall 'six'. It is a distutils installed project and thus we cannot accurately determine which files belong to it which would lead to only a partial uninstall.
```

You can try using `--ignore-installed`. Be aware of the following references:

**TODO**: refine the links below for better explanation.

- [pip 10 and apt: how to avoid “Cannot uninstall X” errors for distutils packages](https://stackoverflow.com/questions/49932759/pip-10-and-apt-how-to-avoid-cannot-uninstall-x-errors-for-distutils-packages)
- [pip cannot uninstall <package>: “It is a distutils installed project”](https://stackoverflow.com/questions/53807511/pip-cannot-uninstall-package-it-is-a-distutils-installed-project/53807588#53807588)
- [Upgrading to pip 10: It is a distutils installed project and thus we cannot accurately determine which files belong to it which would lead to only a partial uninstall.](https://github.com/pypa/pip/issues/5247#issuecomment-443398741)

After you have the databricks-cli installed, you will need to generate an
access token from your Databricks workspace to configure the CLI. To do
so, follow
[this link](https://docs.databricks.com/api/latest/authentication.html).

With the token in hand, use the command below to configure your CLI to connect
to your Databricks workspace:

```bash
databricks configure --token
```

You will be asked to input two information:

- `Databricks Host`: for example, if you created your Databricks workspace
on `East US`, the URL may be `https://eastus.azuredatabricks.net`. To be sure,
open your Databricks workspace and copy the root URL
- `Token`: the token you generated via the Databricks UI on the previous step

To test if your CLI is configured properly, use the following command:

```bash
databricks workspace ls
```

The output should be something like:

```bash
Shared
Users
```

## Create the Databricks cluster

You will create a new Databricks cluster with the following steps.

### Create the JSON metadata

To use Databricks CLI to create a cluster, you need it's metadata as a
JSON file. Create a new JSON file named `cluster.json` with
the following structure:

```json
{
    "num_workers": null,
    "autoscale": {
        "min_workers": 2,
        "max_workers": 8
    },
    "cluster_name": "<cluster name>",
    "spark_version": "5.3.x-scala2.11",
    "spark_conf": {},
    "node_type_id": "Standard_DS3_v2",
    "ssh_public_keys": [],
    "custom_tags": {},
    "spark_env_vars": {
        "PYSPARK_PYTHON": "/databricks/python3/bin/python3"
    },
    "autotermination_minutes": 120,
    "init_scripts": []
}
```

Note that you have fixed values for `cluster_name`, `spark_version`
and `node_type_id`. Make sure that those values are still valid when you
run this solution.

After you have the JSON file crated, use the command below to create
the cluster:

```bash
databricks clusters create --json-file cluster.json
```

You will receive the `cluster_id` right away:

```bash
{
    "cluster_id": "<cluster id>"
}
```

To check the status of this cluster, use:

```bash
databricks clusters list
```

Your cluster will be ready for use when it shows as `RUNNING`:

```bash
<cluster id>  <cluster name>  RUNNING
```

## Create Databricks notebooks to start transforming

After you have your cluster properly created on Databricks, it's time to create
your notebook(s) to start transforming the data that was ingested.

There are many approaches that could be followed at this point. For this
detailed solution purpose, the following structure is proposed:

- One notebook per object below
    - Customers
    - Addresses
    - Movies and Actors will remain together
- Each notebook will
    - Load the Object data from the files on the data lake
    - Bring them together from the different source systems
        - Unify column names, data types
    - Save the unified data as parquet to the data lake

Some cells will be common between all notebooks you will create for this
challenge. Because of that, the detailed solution for each notebook is
broken down by each step of each notebook.

### Notebooks structure

The transformation notebook will have the following structure:

- Define useful functions
- Load the data from the 3 source systems
- Save the concatenated data as a parquet file

Use the detailed steps below to build each notebook.

### Notebooks steps details

#### Customers notebook

Create a new Notebook on Databricks and call it `Customers`. After you have
it created,
[add it to source control](challenge-04/00-add-notebook-source-control.md)
and then follow the steps below, one per cell:

- [1 - Define useful functions](challenge-04/01-define-useful-functions.md)
- 2 - Loading the raw data
    - [2.1 - Loading Southridge Customers](challenge-04/02-loading-raw-data/01-customers/01-loading-southridge-customers.md)
    - [2.2 - Loading VanArsdel Customers](challenge-04/02-loading-raw-data/01-customers/02-load-vanarsdel-customers.md)
    - [2.3 - Loading FourthCoffee Customers](challenge-04/02-loading-raw-data/01-customers/03-loading-fourthcoffee-customers.md)
- 3 - Bringing them all together
    - [3.1 - Bringing all Customers together](challenge-04/03-bring-all-together/01-bring-customers-together.md)
- [4 - Saving the data as parquet to the data lake](challenge-04/04-saving-data-as-parquet.md)

#### Addresses notebook

Create a new Notebook on Databricks and call it `Addresses`. After you have
it created,
[add it to source control](challenge-04/00-add-notebook-source-control.md)
amd then follow the steps below, one per cell:

- [1 - Define useful functions](challenge-04/01-define-useful-functions.md)
- 2 - Loading the raw data
    - [2.1 - Loading Southridge Addresses](challenge-04/02-loading-raw-data/02-addresses/01-loading-southridge-addresses.md)
    - [2.2 - Loading VanArsdel Addresses](challenge-04/02-loading-raw-data/02-addresses/02-load-vanarsdel-addresses.md)
    - [2.3 - Loading FourthCoffee Addresses](challenge-04/02-loading-raw-data/02-addresses/03-loading-fourthcoffee-addresses.md)
- 3 - Bringing them all together
    - [3.1 - Bringing all Addresses together](challenge-04/03-bring-all-together/02-bring-addresses-together.md)
- [4 - Saving the data as parquet to the data lake](challenge-04/04-saving-data-as-parquet.md)

#### Movies and Actors notebook

Create a new Notebook on Databricks and call it `MoviesAndActors`. After you have
it created,
[add it to source control](challenge-04/00-add-notebook-source-control.md)
and then follow the steps below, one per cell:

- [1 - Define useful functions](challenge-04/01-define-useful-functions.md)
- 2 - Loading the raw data
    - [2.1 - Loading Southridge Movies and Actors](challenge-04/02-loading-raw-data/03-movies-actors/01-loading-southridge-moviesandactors.md)
    - [2.2 - Loading VanArsdel Movies and Actors](challenge-04/02-loading-raw-data/03-movies-actors/02-loading-vanarsdel-moviesandactors.md)
    - [2.3 - Loading FourthCoffee Movies and Actors](challenge-04/02-loading-raw-data/03-movies-actors/03-loading-fourthcoffee-moviesandactors.md)
- 3 - Bringing them all together
    - [3.1 - Bringing all Movies and Actors together](challenge-04/03-bring-all-together/03-bring-movies-actors-together.md)
- [4 - Saving the data as parquet to the data lake](challenge-04/04-saving-data-as-parquet.md)

## Learning experiences and road blocks

This reference is incredible and we probably could add:

- [Introduction to DataFrames - Python](https://docs.databricks.com/spark/latest/dataframes-datasets/introduction-to-dataframes-python.html)

- What's the criteria to remove the duplicates between the
CloudSales and CloudStreaming customers?
- There are common customers between Southridge and FourthCoffee and VanArsdel.
What should be the criteria to remove those?
- There's a decision point on what to do about the Southridge's Movies `ReleaseDate`

## Potential feedbacks

- It seems that we cannot see the Service Principal password that's generated
when we use PowerShell, which is different than what happens with the CLI.
For our case, we need to see and copy the password to use on our notebooks,
etc. It would be nice if PowerShell provides an option to retrieve the password
- To upgrade a Databricks Workspace pricing tier, we must *recreate* it with
the same parameter values as the existing one, except for the tier.
[Here's the doc that describes it](https://docs.azuredatabricks.net/administration-guide/account-settings/upgrade-downgrade.html)
- We could add [this tutorial/reference](https://docs.azuredatabricks.net/spark/latest/data-sources/azure/adls-passthrough.html#enable-passthrough-for-a-cluster) to challenge 4 as well.
    - On the other hand, tried to follow this walkthrough but the option to
    enable credential passthrough was not available to me.
    [Screenshot here](challenge-04/images/credential-passthrough-unavailable.jpg).
