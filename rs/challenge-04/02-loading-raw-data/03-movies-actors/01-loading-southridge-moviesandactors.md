# 2.1 Loading Southridge Movies and Actors

The following code will load the Southridge's Movies and Actors:

```python
sr_movies_filepath = mountPoint + "/raw/moviescatalog/movies.json"

sr_movies_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(sr_movies_filepath)
sr_movies_pd = sr_movies_raw.toPandas()

sr_movies_pd = sr_movies_pd[['actors', 'availabilityDate', 'genre', 'id', 'rating', 'releaseYear', 'runtime', 'streamingAvailabilityDate', 'tier', 'title']]

movieactors = sr_movies_pd[['id', 'actors']]
movies = sr_movies_pd[['id', 'title', 'genre', 'availabilityDate', 'rating', 'releaseYear', 'runtime', 'streamingAvailabilityDate', 'tier']]

import numpy as np

actorslist = movieactors.actors.values.tolist()
actorcountbymovie = [len(r) for r in actorslist]
explodedmovieids = np.repeat(movieactors.id, actorcountbymovie)

movieactors = pd.DataFrame(np.column_stack((explodedmovieids, np.concatenate(actorslist))), columns=movieactors.columns)

sr_all_moviesactorsactors = pd.merge(movies, movieactors, on='id')

sr_all_moviesactorsactors = sr_all_moviesactorsactors.rename(index=str, columns={'id': 'MovieID', 'title': 'MovieTitle', 'genre': 'Genre', 'availabilityDate': 'AvailabilityDate', 'rating': 'Rating', 'releaseYear': 'ReleaseYear', 'runtime': 'RuntimeMin', 'streamingAvailabilityDate': 'StreamingAvailabilityDate', 'tier': 'Tier', 'actors': 'ActorName'})

sr_all_moviesactorsactors['ActorID'] = 'None'
sr_all_moviesactorsactors['MovieActorID'] = 'None'
sr_all_moviesactorsactors['ActorGender'] = 'None'
sr_all_moviesactorsactors['ReleaseDate'] = 'None'

sr_all_moviesactorsactors.ReleaseYear = sr_all_moviesactorsactors.ReleaseYear.astype(str)
sr_all_moviesactorsactors.Tier = sr_all_moviesactorsactors.Tier.astype(str)
sr_all_moviesactorsactors.RuntimeMin = sr_all_moviesactorsactors.RuntimeMin.astype(str)

sr_all_moviesactorsactors = sr_all_moviesactorsactors[['MovieID', 'MovieTitle', 'Genre', 'ReleaseDate', 'AvailabilityDate', 'StreamingAvailabilityDate', 'ReleaseYear', 'Tier', 'Rating', 'RuntimeMin', 'MovieActorID', 'ActorID', 'ActorName', 'ActorGender']]
```

## Detailing the code above

You will have detailed information about this code below:

### Loading the data

```python
sr_movies_filepath = mountPoint + "/raw/movies/movies.json"

sr_movies_raw = spark.read.option("multiLine", "true").options(header='true', inferschema='true').json(sr_movies_filepath)
```

> The Southridge's movies catalog is stored on the data lake as a JSON file as
> it was previously loaded from a CosmosDB collection. Because of that, you
> will use `spark.read.json` to load the data as a pyspark DataFrame.

```python
sr_movies_pd = sr_movies_raw.toPandas()
```

> You will convert the pyspark dataframe to a pandas
> DataFrame for ease of transformation.

```python
sr_movies_pd = sr_movies_pd[['actors', 'availabilityDate', 'genre', 'id', 'rating', 'releaseYear', 'runtime', 'streamingAvailabilityDate', 'tier', 'title']]
```

> As a DataFrame which loaded a JSON file will also contain some JSON-specific
> columns, you will need to select only the relevant columns for this scope.

```python
movieactors = sr_movies_pd[['id', 'actors']]
movies = sr_movies_pd[['id', 'title', 'genre', 'availabilityDate', 'rating', 'releaseYear', 'runtime', 'streamingAvailabilityDate', 'tier']]
```

> As the Actors are stored as an Array for each movie, you will first need to
> separate these two information so you will be able to *explode* the Actors,
> joining them back after that. `movieactors` will only contain Actors'
> information and `movies` will only contain movies' data.

### Denormalizing the Movies and Actors relationship

```python
import numpy as np

actorslist = movieactors.actors.values.tolist()
actorcountbymovie = [len(r) for r in actorslist]
explodedactorids = np.repeat(movieactors.id, actorcountbymovie)
```

> This piece of code is important for this scope. In short terms, you will
> explode the Actors array of each movie into a separate temporary
> `movieactors` table so then you can join it with the movies data.
>
> But first of all, as you will use `numpy` to extract the actors data frame,
> you need to import it using `import numpuy as np`.

```python
actorslist = movieactors.actors.values.tolist()
```

> First, you will get a raw list of the actors' names from the `movieactors` dataframe.

```python
actorcountbymovie = [len(r) for r in actorslist]
```

> Then you will identify how many actors each movie has.

```python
explodedmovieids = np.repeat(movieactors.id, actorcountbymovie)
```

> Last, you will create a list of movie ids which will repeat each item for
> every actor the movie has. For example: if the movie *Movie 1* has two actors
> *Actor A*, *Actor B* and the *Movie 2* has three, *Actor A*, *Actor C*
> and *Actor D*, the end data frame would look like this:

|MovieID|ActorID|MovieName|ActorName|
|-------|-------|---------|---------|
|1|A|Movie 1|Actor A|
|1|B|Movie 1|Actor B|
|2|A|Movie 2|Actor A|
|2|C|Movie 2|Actor C|
|2|D|Movie 2|Actor D|

```python
movieactors = pd.DataFrame(np.column_stack((explodedmovieids, np.concatenate(actorslist))), columns=movieactors.columns)
```

> This piece of code creates a new pandas DataFrame with all
> the movie ids (`explodedmovieids`) and its actor names
> (`np.concatenate(actorslist)`)

### Bringing Movies and Actors together

```python
sr_all_moviesactors = pd.merge(movies, movieactors, on='id')
```

Finally, the movies and the actors are joined by the movie `id`

```python
sr_all_moviesactors = sr_all_moviesactors.rename(index=str, columns={'id': 'MovieID', 'title': 'MovieTitle', 'genre': 'Genre', 'availabilityDate': 'AvailabilityDate', 'rating': 'Rating', 'releaseYear': 'ReleaseYear', 'runtime': 'RuntimeMin', 'streamingAvailabilityDate': 'StreamingAvailabilityDate', 'tier': 'Tier', 'actors': 'ActorName'})
```

> With the denormalized movies and actors in hand, this code above renames the
> columns to match a specific pattern that will be used by all the movies
> and actors data frames.

### Conforming the data types

```python
sr_all_moviesactors['ActorID'] = 'None'
sr_all_moviesactors['MovieActorID'] = 'None'
sr_all_moviesactors['ActorGender'] = 'None'
```

> As other data frames may have these fields with values, you will add those
> to this data frame as `None` to prevent dropping them from the other
> data frames.

```python
sr_all_moviesactors.ReleaseYear = sr_all_moviesactors.ReleaseYear.astype(str)
sr_all_moviesactors.Tier = sr_all_moviesactors.Tier.astype(str)
sr_all_moviesactors.RuntimeMin = sr_all_moviesactors.RuntimeMin.astype(str)
```

> These existing columns may have different data types across the other
> data frames. To handle it, you will use string for all of them, on
> all the data frames.

```python
sr_all_moviesactors = sr_all_moviesactors[['MovieID', 'MovieTitle', 'Genre', 'AvailabilityDate', 'StreamingAvailabilityDate', 'ReleaseYear', 'Tier', 'Rating', 'RuntimeMin', 'MovieActorID', 'ActorID', 'ActorName', 'ActorGender']]
```

> After you have all the data transformed properly, you will select the
> relevant - and consistend between all data frames - columns and set it
> to `sr_all_moviesactors`, in an order that will be easier to view.