# Modern Data Warehousing OpenHack Solutions

## Introduction

The Modern Data Warehousing OpenHack consists of a series of challenges
that reflect a progressive implementation of a modern data warehouse,
while adopting and applying certain DevOps practices.
In general, the later challenges are more difficult than the earlier ones,
but this is not always the case.
For example, challenge four involves code to transform and conform extracted data.
Some may find this more complex than challenge five, in which a star schema is populated.
However, given the bottom-up paradigm of modern data warehousing,
it is advantageous to address "fatal" data anomolies and create an intermediate dataset.
The specific use case of serving reports from a star schema can then leverage
the intermediate dataset,
while teams of data scientists are also exploring it to discover unknown unknowns.

The challenges are:

1. Select and provision storage resources for the purpose of
creating an enterprise data lake
1. Extract data from Azure SQL databases into the data lake
1. Extract data from on premises databases into the data lake;
ensure that solution assets are persisted in source control
1. Conform the extracted data into an intermediate dataset which can
satisfy a variety of business needs and user personas;
ensure that the source control solution requires review and approval before merging
1. Leverage the intermediate dataset to populate a star schema
to serve reporting needs;
ensure that the solution supports automated unit testing
1. Implement daily incremental processing;
ensure that telemetry and metrics are gathered and reported
1. Implement automated deployments to a new testing environement
and require explicit approvals before promoting the solution to production

The final two challenges are considered bonus challenges.
These unlock simultaneously after completeion of the five core challenges
and can then be executed in any order.
