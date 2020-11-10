# 2.3 - Loading FourthCoffee Addresses

The following code will load the FourthCoffee customers:

```python
fc_customers_filePath = "/dbfs" + mountPoint + "/raw/fourthcoffee/Customers.csv"

fc_customers_pd = pd.read_csv(fc_customers_filePath)

fc_addresses = fc_customers_pd[['CustomerID', 'AddressLine1', 'AddressLine2', 'City', 'State', 'ZipCode', 'CreatedDate', 'UpdatedDate']]

fc_addresses['CreatedDate'] = pd.to_datetime(fc_addresses['CreatedDate'], errors='coerce')
fc_addresses['UpdatedDate'] = pd.to_datetime(fc_addresses['UpdatedDate'], errors='coerce')
fc_addresses.AddressLine2 = fc_addresses.AddressLine2.astype(str)
fc_addresses.ZipCode = fc_addresses.ZipCode.astype(str)

fc_addresses.loc[fc_addresses.AddressLine2 == 'nan', 'AddressLine2'] = 'None'

fc_addresses.insert(0, 'AddressID', 'None')

display(fc_addresses)
```

## Detailing the code above

You will have detailed information about this code below:

```python
fc_customers_filePath = "/dbfs" + mountPoint + "/raw/fourthcoffee/Customers.csv"

fc_customers_pd = pd.read_csv(fc_customers_filePath)
```

> As FourthCoffee data is saved to the datalake as a CSV file, you will load it
> using `pandas.read_csv`. The loaded data will be a pandas DataFrame already,
> saving some steps to convert it from other formats.

```python
fc_addresses = fc_customers_pd[['CustomerID', 'AddressLine1', 'AddressLine2', 'City', 'State', 'ZipCode', 'CreatedDate', 'UpdatedDate']]
```

> As the DataFrame also contains Customers data, for this scope everything you need
> is their addresses. Because of that, we use the code above to select
> only columns related to customer information, similar to what you have
> on the Southridge data frame.

```python
fc_addresses['CreatedDate'] = pd.to_datetime(fc_addresses['CreatedDate'], errors='coerce')
fc_addresses['UpdatedDate'] = pd.to_datetime(fc_addresses['UpdatedDate'], errors='coerce')
fc_addresses.AddressLine2 = fc_addresses.AddressLine2.astype(str)
fc_addresses.ZipCode = fc_addresses.ZipCode.astype(str)
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
fc_addresses.insert(0, 'AddressID', 'None')
```

> To conform all the data to a same set of columns, you will add the `AddressID`
> to this data frame so it will conform the Southridge's schema. When on a
> *delete vs add empty* decision situation, you will likely go for adding an
> empty column to conform datasets instead of removing data to do so. For more
> information, refer to [this link](../../../_TODOS/delete-or-not.md).

```python
display(fc_addresses)
```

> The last step on this piece of code is to `display` the result of the data
> transformation on the screen, as a table.