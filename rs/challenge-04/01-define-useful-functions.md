# Defining useful functions

The very first cell of all the notebooks for this challenge will have to
declare an important functions for the rest of the challenge.

As each separate notebook is unable to identify if another was run before
its own run, it needs to make sure the data lake file system is mounted
to the Databricks cluster so the files you stored there during ingestion
are available to be loaded and their data transformed.

It also declares a function that will help you save the transformation
result to the data lake as parquet.

The code below sets the stage for the rest of the notebook execution:

```python
import pandas as pd

def mountFileSystem(containerName, storageAccountName):
  configs = {"fs.azure.account.auth.type": "OAuth",
       "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
       "fs.azure.account.oauth2.client.id": "<Service Principal Application ID>",
       "fs.azure.account.oauth2.client.secret": "<Service Principal Application Secret (or password)>",
       "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/<Service Principal Tenant ID>/oauth2/token",
       "fs.azure.createRemoteFileSystemDuringInitialization": "true"}
  
  mountPoint = "/mnt/adls/" + containerName
  
  try:
    dbutils.fs.mount(
      source = "abfss://" + containerName + "@" + storageAccountName + ".dfs.core.windows.net",
      mount_point = mountPoint,
      extra_configs = configs
    )
    print(mountPoint + " mounted successfully")
  except:
    print("The mount " + mountPoint + " already exists.")

  return mountPoint

def saveAsParquet(dataFrame, filePath):
  df = sqlContext.createDataFrame(dataFrame)

  df.write.parquet(filePath, mode='overwrite')

  print(filePath + " saved successfully")

mountPoint = mountFileSystem("southridge", "<storage account name>")
print(mountPoint)
```

## Detailing the code above

The code above is broken down into pieces that make sense separated so they
can be better explained.

### Defining the mountFileSystem function

```python
import pandas as pd
```

> You will use pandas to load and transform the data you ingested.
> This line imports the panda module so it can be used throughout the notebook.

```python
def mountFileSystem(containerName, storageAccountName):
  configs = {"fs.azure.account.auth.type": "OAuth",
       "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
       "fs.azure.account.oauth2.client.id": "<Service Principal Application ID>",
       "fs.azure.account.oauth2.client.secret": "<Service Principal Application Secret (or password)>",
       "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/<Service Principal Tenant ID>/oauth2/token",
       "fs.azure.createRemoteFileSystemDuringInitialization": "true"}
```

> This set of commands do two things:
>
> - declares the `mountFileSystem` function, with two parameters:
>     - `containerName`: the name of the File System on ADLS Gen2 storage
>     - `storageAccountName`: the ADLS Gen2 Storage Account name
> - defines the `configs` variable that defines the parameters for accessing
> the ADLS Gen2 storage through the notebook running on the cluster. For more
> information about this configuration, refer to [this link](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-use-databricks-spark#create-a-file-system-and-mount-it).
>     - Notice the following placeholders:
>         - `<Service Principal Application ID>`
>         - `<Service Principal Application Secret (or password)>`
>         - `<Service Principal Tenant ID>`
>
> Use the information from the Service Principal you created
> before to replace them.

```python
mountPoint = "/mnt/adls/" + containerName
  
  try:
    dbutils.fs.mount(
      source = "abfss://" + containerName + "@" + storageAccountName + ".dfs.core.windows.net",
      mount_point = mountPoint,
      extra_configs = configs
    )
    print(mountPoint + " mounted successfully")
  except:
    print("The mount " + mountPoint + " already exists.")
```

> - The `mountPoint` variable is set to be used
>     - during the file system mount (`dbutils.fs.mount`)
>     - to be returned wherever this function is called, to make it
>     easier to refer to the file system after it is mounted.
> - The exception handling is useful when this code is not run for the first
> time. Instead of mounting the file system again,
> it write a message notifying that the mount already exists.

```python
return mountPoint
```

> No matter if the file system was already mounted or not, the function
> will return the file system path so the consumer code will easily find
> the files to be consumed.

### Defining the saveAsParquet function

```python
def saveAsParquet(dataFrame, filePath):
  df = sqlContext.createDataFrame(dataFrame)
  
  df.write.parquet(filePath, mode='overwrite')
  
  print(filePath + " saved successfully")
```

> The code above declares the `saveAsParquet` function, which receives
> the following parameters:
>
> - `dataFrame`: the pandas DataFrame to be saved as parquet
> - `filePath`: the path to the file to be saved

```python
df = sqlContext.createDataFrame(dataFrame)
```

> A pandas DataFrame does not have the ability to write itself as a parquet
> file, but a pyspark DataFrame does. That's why the command below is executed,
> to convert the pandas DataFrame to a pyspark Dataframe.

```python
df.write.parquet(filePath, mode='overwrite')
  
print(filePath + " saved successfully")
```

> The couple of lines of code above write the pyspark data frame to a parquet
> file to the specified path and then writes the success message.

### Calling the mountFileSystem function

Before anything that's done on the notebook, the file system needs to
be mounted. That's why the `mountFileSystem` function is called right
after itself and the `saveAsParquet` functions are declared, on the
first notebook cell.

```python
...
mountPoint = mountFileSystem("southridge", "<storage account name>")
print(mountPoint)
```

On this example, `southridge` is the File System Data Lake Storage Gen2
container where all the data was ingested through Data Factory.