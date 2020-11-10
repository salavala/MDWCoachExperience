# 2.3 Loading FourthCoffee Movies and Actors

The following code will load the FourthCoffee's Movies and Actors:

```python
fc_movies_filepath = "/dbfs/" + mountPoint + "/raw/fourthcoffee/Movies.csv"
fc_actors_filepath = "/dbfs/" + mountPoint + "/raw/fourthcoffee/Actors.csv"
fc_movieactors_filepath = "/dbfs/" + mountPoint + "/raw/fourthcoffee/MovieActors.csv"

fc_movies_pd = pd.read_csv(fc_movies_filepath)
fc_actors_pd = pd.read_csv(fc_actors_filepath)
fc_movieactors_pd = pd.read_csv(fc_movieactors_filepath)

fc_all_moviesactors = pd.merge(fc_movieactors_pd, fc_movies_pd, on='MovieID')
fc_all_moviesactors = pd.merge(fc_all_moviesactors, fc_actors_pd, on='ActorID')

fc_all_moviesactors = fc_all_moviesactors.rename(index=str, columns={'Category': 'Genre', 'RunTimeMin': 'RuntimeMin', 'Gender': 'ActorGender'})

fc_all_moviesactors['AvailabilityDate'] = 'None'
fc_all_moviesactors['StreamingAvailabilityDate'] = 'None'
fc_all_moviesactors['ReleaseYear'] = 'None'
fc_all_moviesactors['Tier'] = 'None'

fc_all_moviesactors.RuntimeMin = fc_all_moviesactors.RuntimeMin.astype(str)

fc_all_moviesactors = fc_all_moviesactors[['MovieID', 'MovieTitle', 'Genre', 'ReleaseDate', 'AvailabilityDate', 'StreamingAvailabilityDate', 'ReleaseYear', 'Tier', 'Rating', 'RuntimeMin', 'MovieActorID', 'ActorID', 'ActorName', 'ActorGender']]

display(fc_all_moviesactors)
```

## Detailing the code above

You will have detailed information about this code below:

### Loading the data

```python
fc_movies_filepath = mountPoint + "/raw/fourthcoffee/Movies.json"
fc_actors_filepath = mountPoint + "/raw/fourthcoffee/Actors.json"
fc_movieactors_filepath = mountPoint + "/raw/fourthcoffee/MovieActors.json"

fc_movies_pd = pd.read_csv(fc_movies_filepath)
fc_actors_pd = pd.read_csv(fc_actors_filepath)
fc_movieactors_pd = pd.read_csv(fc_movieactors_filepath)
```

> The FourthCoffee's data is stored on the data lake as CSV files
> Because of that, you will use `pandas.read_csv` to
> load the data as a pandas DataFrame.
>
> It will make the process easier because you will not need
> to transform a pyspark DataFrame into a pandas DataFrame.

### Denormalizing the Movies and Actors relationship

```python
fc_all_movies = pd.merge(fc_movieactors_pd, fc_movies_pd, on='MovieID')
fc_all_movies = pd.merge(fc_all_movies, fc_actors_pd, on='ActorID')
```

> After all the data is loaded, you will merge Movies and actors based
> on the `MoviesActors` map table.

```python
fc_all_moviesactors = fc_all_moviesactors.rename(index=str, columns={'Category': 'Genre', 'RunTimeMin': 'RuntimeMin', 'Gender': 'ActorGender'})
```

> To standardize column naming, you will rename those columns to match the
> previously loaded Southridge dataset.

### Conforming data types and columns

```python
fc_all_moviesactors['AvailabilityDate'] = 'None'
fc_all_moviesactors['StreamingAvailabilityDate'] = 'None'
fc_all_moviesactors['ReleaseYear'] = 'None'
fc_all_moviesactors['Tier'] = 'None'
```

> As other data frames may have these fields with values, you will add those
> to this data frame as `None` to prevent dropping them from the other
> data frames.

```python
fc_all_moviesactors.RuntimeMin = fc_all_moviesactors.RuntimeMin.astype(str)
```

> This existing column may have different data type across the other
> data frames. To handle it, you will use string for this column, on
> all the data frames.

```python
fc_all_moviesactors = fc_all_moviesactors[['MovieID', 'MovieTitle', 'Genre', 'ReleaseDate', 'AvailabilityDate', 'StreamingAvailabilityDate', 'ReleaseYear', 'Tier', 'Rating', 'RuntimeMin', 'MovieActorID', 'ActorID', 'ActorName', 'ActorGender']]'ActorGender']]
```

> After you have all the data transformed properly, you will select the
> relevant - and consistent between all data frames - columns and set it
> to `fc_all_moviesactors`, in an order that will be easier to view.