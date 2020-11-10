# 2.1 - Loading Southridge Customers

The following code will load the Southridge customers:

```python
sr_sales_customers_parquet = mountPoint + "/raw/cloudsales/Customers.parquet"
sr_streaming_customers_parquet = mountPoint + "/raw/cloudstreaming/Customers.parquet"

sr_sales_customers = sqlContext.read.parquet(sr_sales_customers_parquet)
sr_streaming_customers = sqlContext.read.parquet(sr_streaming_customers_parquet)

sr_sales_customers = sr_sales_customers.toPandas()
sr_streaming_customers = sr_streaming_customers.toPandas()

sr_customers_frame = [sr_sales_customers, sr_streaming_customers]
sr_customers = pd.concat(sr_customers_frame)

sr_customers['CreatedDate'] = pd.to_datetime(sr_customers['CreatedDate'], errors='coerce')
sr_customers['UpdatedDate'] = pd.to_datetime(sr_customers['UpdatedDate'], errors='coerce')
sr_customers.PhoneNumber = sr_customers.PhoneNumber.astype(str)

display(sr_customers)
```

## Detailing the code above

You will have detailed information about this code below:

### Loading data

```python
sr_sales_customers_parquet = mountPoint + "/raw/cloudsales/Customers.parquet"
sr_streaming_customers_parquet = mountPoint + "/raw/cloudstreaming/Customers.parquet"

sr_sales_customers = sqlContext.read.parquet(sr_sales_customers_parquet)
sr_streaming_customers = sqlContext.read.parquet(sr_streaming_customers_parquet)
```

> As Southridge has two sources for customers - Cloud Sales and Cloud Streaming -
> you will need to load both for latter merging. The code above declares the
> path for both files and also loads them as DataFrames from **parquet**.

```python
sr_sales_customers = sr_sales_customers.toPandas()
sr_streaming_customers = sr_streaming_customers.toPandas()
```

> You will convert both dataframes to Pandas DataFrames for ease of transformation.

### Concatenating the data frames

```python
sr_customers_frame = [sr_sales_customers, sr_streaming_customers]
sr_customers = pd.concat(sr_customers_frame)
```

> The code above creates a new collection of data frames (`sr_customers_frame`)
> so it can be concatenated next and assigned to `sr_customers`.

### Conforming the data types

```python
sr_customers['CreatedDate'] = pd.to_datetime(sr_customers['CreatedDate'], errors='coerce')
sr_customers['UpdatedDate'] = pd.to_datetime(sr_customers['UpdatedDate'], errors='coerce')
sr_customers.PhoneNumber = sr_customers.PhoneNumber.astype(str)
```

> The piece of code above is where we give the dataset a standard for fields
> that might have inconsistency problems:
>
> - `CreatedDate` is converted to a `datetime` column, as well as `UpdatedDate`
> - `PhoneNumber` is converted to a `string` column

```python
display(sr_customers)
```

> The last step on this piece of code is to `display` the result of the data
> transformation on the screen, as a table.