# 3.1 - Bringing all Addresses together

After loading the addresses from the three source systems, the last steps you
need to perform are:

- Add a column to each data frame to track the source systems
- Concat all the three data frames

The code below does that:

```python
sr_addresses['SourceSystem'] = 'southridge'
va_addresses['SourceSystem'] = 'vanarsdel'
fc_addresses['SourceSystem'] = 'fourthcoffee'
addresses_frame = [sr_addresses, va_addresses, fc_addresses]

all_addresses = pd.concat(addresses_frame)

display(all_addresses)
```

## Detailing the code above

```python
sr_addresses['SourceSystem'] = 'southridge'
va_addresses['SourceSystem'] = 'vanarsdel'
fc_addresses['SourceSystem'] = 'fourthcoffee'
```

> For each address data frame you have, this code is adding a new column
> called `SourceSystem` and setting its value with the Source System's name.

```python
addresses_frame = [sr_addresses, va_addresses, fc_addresses]

all_addresses = pd.concat(addresses_frame)
```

> The `addresses_frame` data frame collection is created so it can then be
> concatenated and the result assigned to the `all_addresses` variable.

```python
display(all_addresses)
```

> For validation purposes, the `all_addresses` data frame is displayed.