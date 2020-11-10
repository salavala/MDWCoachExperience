# 2.2 - Loading VanArsdel Customers

The following code will load the VanArsdel customers:

```python
va_customers_filePath = mountPoint + "/raw/vanarsdel/Customers.json"

va_customers_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_customers_filePath)
va_customers_pd = va_customers_raw.toPandas()

va_customers = va_customers_pd[['CustomerID', 'LastName', 'FirstName', 'PhoneNumber', 'CreatedDate', 'UpdatedDate']]

va_customers['CreatedDate'] = pd.to_datetime(va_customers_pd['CreatedDate'], errors='coerce')
va_customers['UpdatedDate'] = pd.to_datetime(va_customers_pd['UpdatedDate'], errors='coerce')

va_customers.PhoneNumber = va_customers_pd.PhoneNumber.astype(str)

display(va_customers)
```

## Detailing the code above

You will have detailed information about this code below:

### Loading the data

```python
va_customers_filePath = mountPoint + "/raw/vanarsdel/Customers.json"

va_customers_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_customers_filePath)
```

> As VanArsdel data is saved to the datalake as a JSON file, you will load it
> using `spark.read.json` with a few options you can see above. The loaded
> data will then be a pyspark DataFrame ready for use.

```python
va_customers_pd = va_customers_raw.toPandas()
```

> You will convert the pyspark dataframe to a Pandas DataFrame for ease of transformation.

### Selecting the relevant data

```python
va_customers = va_customers_pd[['CustomerID', 'LastName', 'FirstName', 'PhoneNumber', 'CreatedDate', 'UpdatedDate']]
```

> As the DataFrame also contains Addresses, for this scope everything you need
> is Customer information. Because of that, we use the code above to select
> only columns related to customer information, similar to what you have
> on the Southridge data frame.

### Conforming the data types

```python
va_customers['CreatedDate'] = pd.to_datetime(va_customers['CreatedDate'], errors='coerce')
va_customers['UpdatedDate'] = pd.to_datetime(va_customers['UpdatedDate'], errors='coerce')

va_customers.PhoneNumber = va_customers.PhoneNumber.astype(str)
```

> The piece of code above is where we give the dataset a standard for fields
> that might have inconsistency problems:
>
> - `CreatedDate` is converted to a `datetime` column, as well as `UpdatedDate`
> - `PhoneNumber` is converted to a `string` column

```python
display(va_customers)
```

> The last step on this piece of code is to `display` the result of the data
> transformation on the screen, as a table.