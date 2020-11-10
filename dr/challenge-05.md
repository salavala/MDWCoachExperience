## Challenge 5: A Star Is Born

This challenge focuses on leveraging the "one stop shop" from the previous challenge
to meet the immediate business intelligence objectives. PBIX files are provided
to the team, but they need to create and populate the schema which serves these reports.

We are documenting the SQL DW solution using Polybase. There are a variety of other paths.
Given the scale of data, teams could also create a star schema in Azure SQL instead of SQL DW.
They may choose to put Analysis Services on top of it.
They may choose to push data into the star schema using a Spark connector rather than Polybase.

### SQL DW Polybase Solution

Refer to the [star-schema](./star-schema/) directory.
Combined with the Coaches Guide, this will step through the key points of the solution.
While this work is pending and the solution is incomplete, the remainder of the
challenge should be a matter of following the same patterns to process the remaining
dimensions and fact tables.

The scripts have been divided into directories which are ordered numerically.
Inside the directory for each stage, the scripts are again ordered numerically.