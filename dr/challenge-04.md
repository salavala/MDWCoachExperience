## Challenge 4: More than meets the eye

This challenge focuses on creating a "one stop shop" for the data in the
data lake. Different personas attempting to meet varying business needs
may have different requirements for their downstream processing, but
one thing that they can **all** benefit from is an intermediate dataset
which smooths out the rough edges of the disparate data systems.

In particular, whether the downstream goal is BI or ML, all teams would like to

- work with a unified dataset which represents the full corpus of enterprise data
- continue using the same dataset no matter how many future stores are required;
i.e., avoid duplication of effort for unioning the new data into the full dataset
- have a common, conformed schema; e.g., if different systems have different names
or use different data types for the same concept, the downstream team should not
need to carry this mental weight

### Target datasets

In the end, we can see the opportunity for five datasets:

1. [Catalog](./notebooks/Conformed%20Catalog.ipynb): All of the movies and actors from all three source systems
1. Customers: All of the people and addresses from all three source systems
1. Sales: All of the orders and order details from Southridge CloudSales
1. Streaming: All of the transaction information from Southridge CloudStreaming
1. Rentals: All of the transaction information from both Fourth Coffee and Van Arsdel, Ltd.

### To join, cleanse, drop duplicates, etc. ... or not

At this stage, we want to focus on the fatal anomalies that would cause exceptions in downstream processing;
e.g., inconsistent data types or formats.
If we were loading this data directly into a final reporting schema,
we would likely apply additional cleansing including, but not limited to:

- Look for and eliminate typos, e.g., PGg instead of PG
- Normalize capitalization of titles, names, ratings, etc.
- Look for and resolve conflicts in matched movies, e.g., Southridge thinks Mysterious Cube is a G-rated family movie
while VanArsdel, Ltd. had it as a PG-13 rated Comedy
- Look for variations in actor names and choose one to use consistently throughout the reporting schema,
e.g., Vivica A. Fox vs Vivica Fox
- Drop duplicates

If we perform these operations now, then we may eliminate the opportunity to discover previously unrecognized value in the data.
As a contrived example, consider a possibility that some actors and actresses would occasionally use a middle initial, but sometimes would not.
Now, imagine that data scientists uncover a trend where films are more marketable when the cast does use a middle initial.
Furthermore, imagine that only holds true in the Drama genre, but it does not hold in Family movies.
If we have already applied a business rule to normalize into the person's "usual" billing, the the data scientists would never be able to see this.

### Establishing a branch policy

> TODO: References are fairly clear on this,
but add some direct guidance here.