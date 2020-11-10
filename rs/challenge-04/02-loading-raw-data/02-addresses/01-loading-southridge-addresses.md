# 2.1 - Loading Southridge Addresses

The following code will load the Southridge addresses:

```python
sr_sales_addresses_parquet = mountPoint + "/raw/cloudsales/Addresses.parquet"
sr_streaming_addresses_parquet = mountPoint + "/raw/cloudstreaming/Addresses.parquet"

sr_sales_addresses = sqlContext.read.parquet(sr_sales_addresses_parquet)
sr_streaming_addresses = sqlContext.read.parquet(sr_streaming_addresses_parquet)

sr_sales_addresses = sr_sales_addresses.toPandas()
sr_streaming_addresses = sr_streaming_addresses.toPandas()

sr_addresses_frame = [sr_sales_addresses, sr_streaming_addresses]
sr_addresses = pd.concat(sr_addresses_frame)

sr_addresses['CreatedDate'] = pd.to_datetime(sr_addresses['CreatedDate'], errors='coerce')
sr_addresses['UpdatedDate'] = pd.to_datetime(sr_addresses['UpdatedDate'], errors='coerce')

sr_addresses.AddressLine2 = sr_addresses.AddressLine2.astype(str)
sr_addresses.ZipCode = sr_addresses.ZipCode.astype(str)

display(sr_addresses)
```

## Detailing the code above

You will have detailed information about this code below:

```python
sr_sales_addresses_parquet = mountPoint + "/raw/cloudsales/Addresses.parquet"
sr_streaming_addresses_parquet = mountPoint + "/raw/cloudstreaming/Addresses.parquet"

sr_sales_addresses = sqlContext.read.parquet(sr_sales_addresses_parquet)
sr_streaming_addresses = sqlContext.read.parquet(sr_streaming_addresses_parquet)
```

> As Southridge has two sources for addresses - Cloud Sales and Cloud Streaming -
> you will need to load both for latter merging. The code above declares the
> path for both files and also loads them as DataFrames from **parquet**.

```python
sr_sales_addresses = sr_sales_addresses.toPandas()
sr_streaming_addresses = sr_streaming_addresses.toPandas()
```

> You will convert both dataframes to Pandas DataFrames for ease of transformation.

```python
sr_addresses_frame = [sr_sales_addresses, sr_streaming_addresses]
sr_addresses = pd.concat(sr_addresses_frame)
```

> The code above creates a new collection of data frames (`sr_addresses_frame`)
> so it can be concatenated next and assigned to `sr_addresses`.

```python
sr_addresses['CreatedDate'] = pd.to_datetime(sr_addresses['CreatedDate'], errors='coerce')
sr_addresses['UpdatedDate'] = pd.to_datetime(sr_addresses['UpdatedDate'], errors='coerce')

sr_addresses.AddressLine2 = sr_addresses.AddressLine2.astype(str)
sr_addresses.ZipCode = sr_addresses.ZipCode.astype(str)
```

> The piece of code above is where we give the dataset a standard for fields
> that might have inconsistency problems:
>
> - `CreatedDate` is converted to a `datetime` column, as well as `UpdatedDate`
> - `AddressLine2` will likely contain `null` values, which may cause problems
> during data concatenation and type inferring. To avoid this, you will convert
> this column to a `string` column
> - `ZipCode` is converted to a `string` column

```python
display(sr_addresses)
```

> The last step on this piece of code is to `display` the result of the data
> transformation on the screen, as a table.