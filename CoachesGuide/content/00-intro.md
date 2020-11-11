# Coaches Guide - Modern Data Warehousing

## OpenHack - An Introduction for Coaches

OpenHack is a hands-on experience in which participants work in team to solve a
series of coding challenges based on the requirements and resources provided. It
is *not* designed to be delivered as a traditional training session or hands-on
lab.

Your role as a coach is to encourage your team to work together to solve the
challenges for themselves. You may provide critical assessment of their ideas
and suggest potential avenues of exploration when they get stuck; but you should
*not* provide solutions to the challenges. The outcome that customers value most
from OpenHack is the satisfaction of having solved the challenges for
themselves, and the in-depth learning that comes from that experience.

So what *is* expected of a coach?

- Facilitating intra- (and inter-) team work to solve the challenges. Lead
    team discussions, being sure to include all team members. Act as a “sounding
    board” for team brainstorming while helping the team focused on the
    challenges and their success criteria.

- Unblocking technical issues that are not directly related to the challenges
    (for example, command line syntax or network authentication issues).

- Explaining underlying concepts where necessary. Participants can often find
    the code they need in documentation or on sites like StackOverflow; but they
    may have difficulty understanding what it is that they’re actually doing.

- Managing team sentiment and morale – the challenges are designed to be, er,
    challenging; and as a result, some participants may experience frustration
    at times during the OpenHack. Coaches need to be sensitive to the mood of
    the team and help steer them towards a breakthrough by asking leading
    questions, proposing alternative avenues of exploration, or just suggesting
    a coffee break.

- Validating challenge solutions against the specified criteria, and approving
    team progress through the challenges; being sure to celebrate the team’s
    successes along the way!

## Preparing to Coach the Modern Data Warehousing OpenHack

Before coaching the Modern Data Warehousing OpenHack, you should ensure you are
fully prepared.

### 1. Build Foundational Knowledge

Coaches for the MDW OpenHack require a knowledge of fundamental ETL and data
warehousing concepts, and familiarity with tools commonly used to move and
process data.

- Start by reading the Microsoft white paper on Modern Data Warehousing at
<https://aka.ms/msftmdw>, and the architectural guidance at
<https://azure.microsoft.com/en-us/solutions/architecture/modern-data-warehouse>.
- You will also find a great deal of overlap in the “Perform data engineering with Azure Databricks” learning path at <https://aka.ms/learnmdw>.

### 2. Complete the OpenHack Challenges

Ideally, you should attend the MDW OpenHack as a participant before coaching
it. If this is not possible, you should complete all the challenges on your
own. You should try to complete the challenges using only the instructions
that the OpenHack participants will have, but you can also use the notes in
the rest of this guide for more detailed information and context that may
help you coach your team during the OpenHack itself.

> **Note**: If a **solutions** folder is provided for this OpenHack,
> these solutions were used to validate the challenges.
> Obviously, you might find this useful; but we encourage you to try to
> *solve the challenges for yourself before referring to the solutions*.
>
> The **solutions** folder includes solutions for paths that we anticipate
> being the most common choices. As a coach, you must allow a team to choose
> alternative paths, if the success criteria is met. It is **not** expected
> that a coach will have deep expertise in all possible paths, nor expert
> level command of all possible syntax. Coaches can lean on each other for
> help if a team chooses a less familiar path. If no coach has experience with
> the team’s chosen path, this is a growth opportunity for the coach to join
> in and learn **with** the team.

### 3. Prepare to Support Your Team

The guidance in the rest of this document incorporates insights from the
content authors that describe the learning objectives for the challenges and
how they are intended to be used, as well as hints and tips from previous
coaches who have successfully helped customers as they work through the
challenges. Be sure to read through these notes, as they will help you
ensure your team has a positive and successful OpenHack experience.

## Challenge Guidance

The rest of this document provides guidance for helping your team as they work
through the challenges.

### General Expectations

The OpenHack consists of a series of challenges that reflect a logical order for
implementing a modern data warehouse, while adopting and applying certain DevOps
practices. In general, the later challenges are more difficult than the earlier
ones; but this is not always the case. For example, the second challenge
requires attendees to write code to transform and cleanse extracted data.
Depending on their previous experience, they may find this more difficult than a
later challenge for creating a star schema. However, given the bottom-up
approach for modern data warehousing, we would advise customers to make the data
generally available for various use cases *before* meeting a specific use case
of the star schema – hence the ordering of these challenges.

Most teams will *not* complete all the challenges within the time available.
This is by-design (it’s better to have some *stretch-goal* challenges for
experienced attendees who may get through the challenges unusually quickly than
to run out of challenges partway through the event!) As a general rule, the
authors expect 80-90% of attendees to complete only the first 3 challenges
within a 3-day event (an average of two challenges per-day) – if your team does
that, they’ll have learned a great deal about implementing and operationalizing
an MDW! The remaining challenges represent more advanced scenarios (unit testing
and automated deployments) and will likely only be tackled by attendees who
already have some experience with ETL techniques.

If your team does not reach the final challenge, at the end of the event you can
unlock the remaining challenges and allow them to copy the challenge text and
links. The OpenHack portal and associated Azure subscriptions will be deleted
when the event ends, but attendees are welcome to use their own Azure
subscription to continue working on the challenges on their own time provided
they agree that **they will not publish the challenges or their solutions in any
public location** (such as a GitHub repo or blog). We want future attendees to
have a great OpenHack experience, and if it’s easy for them to find challenge
solutions from previous attendees then they will not get the full benefit of
having to work on the challenges for themselves.

### Handling Participants with Insufficient Scala or Python Skills

The prerequisite skills for this OpenHack include some knowledge of Scala or
Python, however it’s not uncommon for participants to not meet this requirement.
If your team includes participants without programming experience in these
languages, you may be able to help them by:

- Ensure that the team is aware that they can use sql in an Azure Databricks
    notebook:
    <https://docs.azuredatabricks.net/spark/latest/spark-sql/index.html>
- Directing them to sample notebooks that provide syntactical references and
    helpers for common tasks
    - <https://github.com/dmakogon/iot-data-openhack-helpers>
    - [Analyzing European Soccer
        Leagues](https://databricks.com/blog/2018/07/09/analyze-games-from-european-soccer-leagues-with-apache-spark-and-databricks.html),
        or directly download the [notebook
        dbc](https://databricks.com/blog/2018/07/09/analyze-games-from-european-soccer-leagues-with-apache-spark-and-databricks.html)
- Demonstrating how to use autocomplete in Notebooks (by pressing TAB) and,
    when using Python, how to get syntactical help (by using the
    help(*library\|command*)method.
- Demonstrating how to use the Python Debugger in Notebooks (including using
    the %%debug magic to enable debugging for an entire cell). See
    <https://docs.python.org/2/library/pdb.html> for debugging documentation.
- Having them edit code in Visual Studio Code to benefit from intellisense.
