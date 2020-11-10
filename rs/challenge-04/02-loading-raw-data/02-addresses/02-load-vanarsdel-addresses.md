# 2.2 - Loading VanArsdel Addresses

The following code will load the VanArsdel addresses:

```python
va_customers_filePath = mountPoint + "/raw/vanarsdel/Customers.json"

va_customers_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_customers_filePath)
va_customers_pd = va_customers_raw.toPandas()

va_addresses = va_customers_pd[['CustomerID', 'AddressLine1', 'AddressLine2', 'City', 'State', 'ZipCode', 'CreatedDate', 'UpdatedDate']]

va_addresses['CreatedDate'] = pd.to_datetime(va_addresses['CreatedDate'], errors='coerce')
va_addresses['UpdatedDate'] = pd.to_datetime(va_addresses['UpdatedDate'], errors='coerce')

va_addresses.AddressLine2 = va_addresses.AddressLine2.astype(str)
va_addresses.ZipCode = va_addresses.ZipCode.astype(str)

va_addresses.insert(0, 'AddressID', 'None')

display(va_addresses)
```

## Detailing the code above

You will have detailed information about this code below:

```python
va_addresses_filePath = mountPoint + "/raw/vanarsdel/Addresses.json"

va_addresses_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_addresses_filePath)
```

> As VanArsdel data is saved to the datalake as a JSON file, you will load it
> using `spark.read.json` with a few options you can see above. The loaded
> data will then be a pyspark DataFrame ready for use.

```python
va_addresses_pd = va_addresses_raw.toPandas()
```

> You will convert the pyspark dataframe to a pandas DataFrame for ease of transformation.

```python
va_addresses = va_addresses_pd[['CustomerID', 'LastName', 'FirstName', 'PhoneNumber', 'CreatedDate', 'UpdatedDate']]
```

> As the DataFrame also contains Customers information, for this scope everything you need
> is their addresses. Because of that, we use the code above to select
> only columns related to customer information, similar to what you have
> on the Southridge data frame.

```python
va_addresses['CreatedDate'] = pd.to_datetime(va_addresses['CreatedDate'], errors='coerce')
va_addresses['UpdatedDate'] = pd.to_datetime(va_addresses['UpdatedDate'], errors='coerce')

va_addresses.AddressLine2 = va_addresses.AddressLine2.astype(str)
va_addresses.ZipCode = va_addresses.ZipCode.astype(str)
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
va_addresses.insert(0, 'AddressID', 'None')
```

> To conform all the data to a same set of columns, you will add the `AddressID`
> to this data frame so it will conform the Southridge's schema. When on a
> *delete vs add empty* decision situation, you will likely go for adding an
> empty column to conform datasets instead of removing data to do so. For more
> information, refer to [this link](../../../_TODOS/delete-or-not.md).

```python
display(va_addresses)
```

> The last step on this piece of code is to `display` the result of the data
> transformation on the screen, as a table.