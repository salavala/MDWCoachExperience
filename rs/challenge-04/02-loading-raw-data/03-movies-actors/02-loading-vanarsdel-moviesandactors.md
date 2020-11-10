# 2.2 Loading VanArsdel Movies and Actors

The following code will load the VanArsdel's Movies and Actors:

```python
va_movies_filepath = mountPoint + "/raw/vanarsdel/Movies.json"
va_actors_filepath = mountPoint + "/raw/vanarsdel/Actors.json"
va_movieactors_filepath = mountPoint + "/raw/vanarsdel/MovieActors.json"

va_movies_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_movies_filepath)
va_actors_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_actors_filepath)
va_movieactors_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_movieactors_filepath)

va_movies_pd = va_movies_raw.toPandas()
va_actors_pd = va_actors_raw.toPandas()
va_movieactors_pd = va_movieactors_raw.toPandas()

va_all_movies = pd.merge(va_movieactors_pd, va_movies_pd, on='MovieID')
va_all_movies = pd.merge(va_all_movies, va_actors_pd, on='ActorID')

va_all_movies = va_all_movies.rename(index=str, columns={'Category': 'Genre', 'RunTimeMin': 'RuntimeMin', 'Gender': 'ActorGender'})

va_all_movies['AvailabilityDate'] = 'None'
va_all_movies['StreamingAvailabilityDate'] = 'None'
va_all_movies['ReleaseYear'] = 'None'
va_all_movies['Tier'] = 'None'

va_all_movies.RuntimeMin = va_all_movies.RuntimeMin.astype(str)

va_all_movies = va_all_movies[['MovieID', 'MovieTitle', 'Genre', 'ReleaseDate', 'AvailabilityDate', 'StreamingAvailabilityDate', 'ReleaseYear', 'Tier', 'Rating', 'RuntimeMin', 'MovieActorID', 'ActorID', 'ActorName', 'ActorGender']]

va_all_movies.dtypes
```

## Detailing the code above

You will have detailed information about this code below:

### Loading the data

```python
va_movies_filepath = mountPoint + "/raw/vanarsdel/Movies.json"
va_actors_filepath = mountPoint + "/raw/vanarsdel/Actors.json"
va_movieactors_filepath = mountPoint + "/raw/vanarsdel/MovieActors.json"

va_movies_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_movies_filepath)
va_actors_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_actors_filepath)
va_movieactors_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(va_movieactors_filepath)
```

> The VanArsdel's data is stored on the data lake as JSON files
> Because of that, you will use `spark.read.json` to
> load the data as a pyspark DataFrame.

```python
va_movies_pd = va_movies_raw.toPandas()
va_actors_pd = va_actors_raw.toPandas()
va_movieactors_pd = va_movieactors_raw.toPandas()
```

> You will convert the pyspark dataframes to pandas
> DataFrames for ease of transformation.

### Denormalizing the Movies and Actors relationship

```python
va_all_movies = pd.merge(va_movieactors_pd, va_movies_pd, on='MovieID')
va_all_movies = pd.merge(va_all_movies, va_actors_pd, on='ActorID')
```

> After all the data is loaded, you will merge Movies and actors based
> on the `MoviesActors` map table.

```python
va_all_moviesactors = va_all_moviesactors.rename(index=str, columns={'Category': 'Genre', 'RunTimeMin': 'RuntimeMin', 'Gender': 'ActorGender'})
```

> To standardize column naming, you will rename those columns to match the
> previously loaded Southridge dataset.

### Conforming data types and columns

```python
va_all_moviesactors['AvailabilityDate'] = 'None'
va_all_moviesactors['StreamingAvailabilityDate'] = 'None'
va_all_moviesactors['ReleaseYear'] = 'None'
va_all_moviesactors['Tier'] = 'None'
```

> As other data frames may have these fields with values, you will add those
> to this data frame as `None` to prevent dropping them from the other
> data frames.

```python
va_all_moviesactors.RuntimeMin = va_all_moviesactors.RuntimeMin.astype(str)
```

> This existing column may have different data type across the other
> data frames. To handle it, you will use string for this column, on
> all the data frames.

```python
va_all_moviesactors = va_all_moviesactors[['MovieID', 'MovieTitle', 'Genre', 'ReleaseDate', 'AvailabilityDate', 'StreamingAvailabilityDate', 'ReleaseYear', 'Tier', 'Rating', 'RuntimeMin', 'MovieActorID', 'ActorID', 'ActorName', 'ActorGender']]'ActorGender']]
```

> After you have all the data transformed properly, you will select the
> relevant - and consistent between all data frames - columns and set it
> to `va_all_moviesactors`, in an order that will be easier to view.