--- 
title: About Logical Data Independence
short: Logical Data Independence
subtitle: Let's celebrate the birthday of Relational
date: 2009-11-20 19:12:00 +01:00
category: Databases
keywords: 
- database
- logical data independence
- independence
- views
---
I'm really happy to write about databases today! The Relational model, invented by Edgar F. Codd, might have been born about 40 years ago (the official paper is dated from 1970, but the first draft was actually written in 1969) but in my opinion a lot of research and development still needs to occur for Codd's dream to become a reality.

For a really long time, I wanted to write somewhing about what has been called 'logical data independence' but I didn't  find a good example to illustrate that concept until today. I've just found it now, inspired by a real but simple  application! So let's talk about it. The topic matters: even famous computer scientists wrongly confuse logical and physical data independence... and developers don't even imagine how such an independence could make their job easier! Nevertheless I must confess that logical data independence is somewhat loosely defined... Therefore let me start by sharing my developer's point of view on what it means.

## Independence?

What does 'logical (data) independence' mean? Well, there are two axes in there: the concept of 'independence', and the 'logical' one. The concept of 'independence' is related to 'change'; the main question 'independence' addresses is:

> How does a given change affect the code of the software ?

That is something that can be measured: decide to make a change to the current version of your software, implement it, commit it, and count the number of lines of code that have changed between the two versions. Actually, tallying up the numbers of changed lines is not the best measure and I strongly prefer counting how many packages/modules (if you have an abstract module decomposition) and/or classes (if you don't) have been affected by the change.

At the risk of sounding like a theorist, 'change' can also be seen in the light of requirements. What are changing requirements? Well, there's a lot to it but the most important in my experience is 'New requirements'. In other words, the need for new features! New features are much more important than everything else: they demonstrate that the software is living, that people use it, like it (at least, we hope so), and want it to evolve! I like new features, and I like new features a lot more if developing them does not affect the code of existing ones. This is where independence comes into play! To me, independence is the complement of rigorous testing: 

> Tests assert that requirements are still met (and by transitivity that features implementing them seem correct) when the code needs to change;

> Independence helps avoiding to have to alter existing code too much when implementing changes.

In this article, I am talking about 'data independence'. My point so far is about 'architectural independence' at large, also called 'weak coupling': two modules <code>A</code> and <code>B</code> are weakly coupled if changing the code of one does not affect the second. However, a distinction between two kinds of code modification is worth considering here. The reason is that a module has an external specification (and an external, public API together with pre and post-conditions) and an internal (and generally private) implementation. Therefore independence is two-fold: one has to think about the effect of external changes (modification and/or extension of the API, for instance) and of internal changes (selection of a better algorithm for the same task). 

In practice, a good architecture (the object-oriented programming generally helps here) hides implementation details behind well designed interfaces. Programmers are then invited to code to the interface, not to the implementation. Doing so helps achieving a strong independence: you can make important internal changes to a module without hurting the ones that use it. Making external changes is another story, because it involves changing the interface itself! 

![](images/logical_data_independence/modules.gif)

## What about the Database?

A database is nothing else than a specific architectural module. Therefore a similar reasoning about internal/external changes can be made. However, if the internal vs. external distinction is generally described by programmers in terms of "interface vs. implementation" (as I've just done myself), I feel more comfortable here thinking in terms of "internal vs. external specifications". The reason is simply that a 'database interface' sounds a technical object (some kind of API) while the concept of "data independence" is certainly not. 

Now, we can certainly consider the database as a first module <code>A</code> and the rest of the software code as a second module <code>B</code>, even if doing so appears a bit arbitrary. Then, may certainly ask oneself how much is the software code affected by changes of the database. And loosely speaking, 'physical' and 'logical' data independence correspond to the independence against internal and external changes, respectively. Let me add that physical independence has been achieved for a long time now (but seems to somewhat disappear in my opinion) but the logical one has never been reached (in my opinion still).

![](images/logical_data_independence/database.gif)

To better understand the two kinds of independence, we obviously need to make specifications of the database more precise. One of Codd's main contributions with the relational model has been to improve the separation between the external and internal specifications of a database:

<b>External specification</b>: a database offers the ability to express 'what' the data of interest is for a given task through a logical schema of the data (when taking about a relational database, this logical level is strongly rooted in mathematics, in first order logic in particular) and 'deduction operators' (the relational algebra) that allow that data to be queried (the term 'deduction' comes from the fact that if a database is a collection of known facts - and it is! - then a query does nothing else than deducing new facts from existing ones). An important part of the external specification of a database is the respect of ACID properties (Atomicity, Consistency, Isolation and Durability). The fact that query results are always correct is related to Consistency.
 
<b>Internal specification</b>: no matter what information paths are choosen (for example index selection) for executing a particular query, the query execution must return correct results. Moreover, we expect the database implementation to be smart enough to select a good query plan ensuring a good query execution performance. This is where the query optimizer comes into play, turning the 60's developer (who was selecting information path by explicit application coding) to the 80's database administrator (who creates new indexes, analyzes query plans and so on, independently of the application code itself). More generally, the internal specification is related to the effective implementation of the ACID properties through extremely complex physical mechanisms that you don't have to worry about as an application developer. Thanks a lot Mr Codd!

Let's now discuss physical and logical independence in turn.

## Physical data independence

The first kind of independence is related to a change to the internal implementation of the database. The fact is that a long time ago (in the 60's and 70's, I wasn't even born...), when you had to keep information about employees working in departments, you typically kept records about employees in a flat file and maintained a pointer to the department record in the employee record. To create a report with employees belonging to a given department, you had to iterate employees' records in the flat file (through file cursors and such kind of physical abstractions), gathering those that reference the correct department record by following the pointer. When the way the data was kept on disk was changed (for example through the introduction of an index file directly mapping the list of employees engaged in a given department), the report's code had to change as well (to take profit of this new index, for performance of course)! In other words, there was no data independence.

![](images/logical_data_independence/empdept.gif)

With the introduction of the Relational model (and SQL databases, which are the best (non-)relational implementation we have today), things have changed. The report's code is now some variation around the following:

<center><code>SELECT * FROM employees WHERE dept_id=...</code></center>

Observe this query a moment. The most important thing is not that it is declarative (it's probably required for independence, but not important <i>per se</i>). The important fact is that the query is independent of the way the data is physically stored: flat files, B-trees, hash indexes can all be chosen as physical storage and indexing of employee and department records as well as their 'connection' through <code>dept_id</code>. This means that:

> The source code of the report must NOT change even if you change the way the data is organized on disk. 

So when talking about changes: you can add or remove indexes, change the way base tables are kept on disk, etc. without affecting the application's code. The responsibility of ensuring that the query can be executed and returns the correct results as well as the choice of available information paths used to do so (what index will be used, for example) is left to the database management system (DBDM), not the application itself. This is what physical independence means!

## Logical data independence

What about logical data independence? According to database books, physical independence means <b>non-intrusive changes of the physical schema</b> where logical independence means <b>non-intrusive changes of the logical one</b>. Physical schema modifications are generally well discussed in database books (index creation, suppression, and so on) and the physical independence well understood by students (they often forget everything about it a bit later, of course!). Examples of logical schema modification are much less convincing in my opinion: renaming or suppression of an attribute (or a table column, if you prefer that vocabulary), removal of a table, and so on. They are logical schema changes, of course, but not good examples! Strictly speaking if I remove a database table for real, I don't see how the application code using that table could not be affected...

Better books relate logical independence to views ... without providing any convincing example I must add. However, it is perfectly correct! Logical independence is strongly related to views. I would add that a database that does not provide a real, complete and transparent view mechanism (including a way to update views) is strictly unable to provide logical data independence. Strictly speaking, views do not offer logical data independence <i>per se</i> but they are the way (or at least one of the best ways) to achieve that goal. I've stated earlier that "logical independence has never been reached"... I close this first paper with a short explanation of that sentence: few DBMS provide a good view mechanism, few SQL DBMS allow updating views (automatically or through triggers or rules written by the DBA), no support is provided by SQL DBMS to manage logical changes through successive schema versions and few DBAs know how to use views in the correct way.

The story does not end here, of course. The @{logical_data_independence_2}{next paper} will show a real but simple (and I hope convincing) example of what 'logical data independence' may really mean in practice.