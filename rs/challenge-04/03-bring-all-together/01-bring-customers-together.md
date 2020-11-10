# 3.1 - Bringing all Customers together

After loading the customers from the three source systems, the last steps you
need to perform are:

- Add a column to each data frame to track the source systems
- Concat all the three data frames

The code below does that:

```python
sr_customers['SourceSystem'] = 'southridge'
va_customers['SourceSystem'] = 'vanarsdel'
fc_customers['SourceSystem'] = 'fourthcoffee'
customers_frame = [sr_customers, va_customers, fc_customers]

all_customers = pd.concat(customers_frame)

display(all_customers)
```

## Detailing the code above

```python
sr_customers['SourceSystem'] = 'southridge'
va_customers['SourceSystem'] = 'vanarsdel'
fc_customers['SourceSystem'] = 'fourthcoffee'
```

> For each customer data frame you have, this code is adding a new column
> called `SourceSystem` and setting its value with the Source System's name.

```python
customers_frame = [sr_customers, va_customers, fc_customers]

all_customers = pd.concat(customers_frame)
```

> The `customers_frame` data frame collection is created so it can then be
> concatenated and the result assigned to the `all_customers` variable.

```python
display(all_customers)
```

> For validation purposes, the `all_customers` data frame is displayed.