# 4 - Saving the data as parquet to the data lake

This method for saving the pandas DataFrame as a parquet file to the data lake
works identically for all the three business objects (`Addresses`, `Customers`
and the `Movies and Actors`).

Given that, the following code will be shown with placeholders for each of these
business objects:

```python
parquet_path = mountPoint + '/parquet/<Business Object name>.parquet'

saveAsParquet(all_<business object name>, parquet_path)
```

## Detailing the code above

```python
parquet_path = mountPoint + '/parquet/<Business Object name>.parquet'
```

> This line of code will combine the two strings to create the full path
> for the parquet file to be saved to the data lake.

```python
saveAsParquet(all_<business object name>, parquet_path)
```

> The line of code above will use the function `saveAsParquet` defined on
> the first cell to save the transformation result as a parquet file
> to the data lake.