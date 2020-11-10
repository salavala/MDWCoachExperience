# 2.3 - Loading FourthCoffee Customers

The following code will load the FourthCoffee customers:

```python
fc_customers_filePath = "/dbfs" + mountPoint + "/raw/fourthcoffee/Customers.csv"

fc_customers_pd = pd.read_csv(fc_customers_filePath)

fc_customers = fc_customers_pd[['CustomerID', 'LastName', 'FirstName', 'PhoneNumber', 'CreatedDate', 'UpdatedDate']]

fc_customers['CreatedDate'] = pd.to_datetime(fc_customers_pd['CreatedDate'], errors='coerce')
fc_customers['UpdatedDate'] = pd.to_datetime(fc_customers_pd['UpdatedDate'], errors='coerce')
fc_customers.PhoneNumber = fc_customers_pd.PhoneNumber.astype(str)

display(fc_customers)
```

## Detailing the code above

You will have detailed information about this code below:

### Loading the data

```python
fc_customers_filePath = "/dbfs" + mountPoint + "/raw/fourthcoffee/Customers.csv"

fc_customers_pd = pd.read_csv(fc_customers_filePath)
```

> As FourthCoffee data is saved to the datalake as a CSV file, you will load it
> using `pandas.read_csv`. The loaded data will be a pandas DataFrame already,
> saving some steps to convert it from other formats.

### Selecting the relevant data

```python
fc_customers = fc_customers_pd[['CustomerID', 'LastName', 'FirstName', 'PhoneNumber', 'CreatedDate', 'UpdatedDate']]
```

> As the DataFrame also contains Addresses, for this scope everything you need
> is Customer information. Because of that, we use the code above to select
> only columns related to customer information, similar to what you have
> on the Southridge data frame.

### Conforming the data types

```python
fc_customers['CreatedDate'] = pd.to_datetime(fc_customers['CreatedDate'], errors='coerce')
fc_customers['UpdatedDate'] = pd.to_datetime(fc_customers['UpdatedDate'], errors='coerce')
fc_customers.PhoneNumber = fc_customers.PhoneNumber.astype(str)
```

> The piece of code above is where we give the dataset a standard for fields
> that might have inconsistency problems:
>
> - `CreatedDate` is converted to a `datetime` column, as well as `UpdatedDate`
> - `PhoneNumber` is converted to a `string` column

```python
display(fc_customers)
```

> The last step on this piece of code is to `display` the result of the data
> transformation on the screen, as a table.