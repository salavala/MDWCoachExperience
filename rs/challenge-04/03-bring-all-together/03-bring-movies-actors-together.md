# 3.1 - Bringing all Movies and Actors together

After loading the movies and actors from the three source systems, the last
steps you need to perform are:

- Add a column to each data frame to track the source systems
- Concat all the three data frames

The code below does that:

```python
sr_all_moviesactors['SourceSystem'] = 'southridge'
va_all_moviesactors['SourceSystem'] = 'vanarsdel'
fc_all_moviesactors['SourceSystem'] = 'fourthcoffee'

moviesactors_frame = [sr_all_moviesactors, va_all_moviesactors, fc_all_moviesactors]

all_moviesactors = pd.concat(moviesactors_frame)

display(all_moviesactors)
```

## Detailing the code above

```python
sr_all_moviesactors['SourceSystem'] = 'southridge'
va_all_moviesactors['SourceSystem'] = 'vanarsdel'
fc_all_moviesactors['SourceSystem'] = 'fourthcoffee'
```

> For each movies/actors data frame you have, this code is adding a new column
> called `SourceSystem` and setting its value with the Source System's name.

```python
moviesactors_frame = [sr_all_moviesactors, va_all_moviesactors, fc_all_moviesactors]

all_moviesactors = pd.concat(moviesactors_frame)
```

> The `moviesactors_frame` data frame collection is created so it can then be
> concatenated and the result assigned to the `all_moviesactors` variable.

```python
display(all_moviesactors)
```

> For validation purposes, the `all_moviesactors` data frame is displayed.