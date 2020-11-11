## Challenge 6: It’s Groundhog Day… again

With pipelines established to extract and transform the bulk data from all
source systems, the team must now address the ongoing needs of the business.
Data from each new day of business needs to be added to the data lake, but it
would be inefficient to repeatedly process all of the historical data. The team
will implement an incremental load, and will establish a logging and telemetry
solution by which they can monitor the amount of newly incorporated data.

### Incremental loads

The team will benefit from using a watermark pattern.

<https://docs.microsoft.com/en-us/azure/data-factory/tutorial-incremental-copy-overview>

Note that this is an overview reference, and a variety of more specific references
exist if the documentation tree is expanded.

Specific tutorials under the overview include

- copying data from tables
- copying files by their last modified date
- copying files by a time partitioned file name

### Logging and Telemetry

> The team has a great deal of freedom here. At the end of the day, the number
> of records extracted and processed from each source system should be logged
> somewhere.
>
> One solution could be Databricks with Application Insights:
> <https://msdn.microsoft.com/en-us/magazine/mt846727.aspx>
>
> Another could be logging the row counts to a new table in a database built
> for this purpose.

### Understanding possible `MoveData` execution errors for

#### Data already imported

If the `MoveData` procedure throws an error such as the following, then the team should move to the next date.
The following error indicates that the desired data has already been moved into the `Transactions` table.

```sql
Msg 4904, Level 16, State 1, Procedure dbo.MoveData, Line 21 [Batch Start Line 0]
ALTER TABLE SWITCH statement failed. The specified partition 2 of target table 'OnPremRentals.dbo.Transactions' must be empty.
```

#### Data loaded in an incorrect order

If the `MoveData` procedure throws an error such as the following, then the team should confirm
that movement has started with '2018-01-01' and is moving forward one day at a time.
The following error indicates that there is no data for the requested date.

```sql
Msg 4957, Level 16, State 3, Procedure dbo.MoveData, Line 18 [Batch Start Line 0]
'ALTER TABLE' statement failed because the expression identifying partition number for the table 'Customers' is not of integer type.
```
