--- 
title: Relational Basics I
short: Relational Basics I
date: 2011-12-11 20:32:00 +01:00
category: Databases
keywords: 
- database
- relational theory
- relational model
- information principle
- relational algebra
- types
- ruby
---
I'd like to write a few essays related to relational databases in the next weeks, such as discussing migrations from a logical point of view or presenting some relational operators implemented in @{http://blambeau.github.com/alf/overview/index.html}{Alf} and borrowed from @{http://en.wikipedia.org/wiki/D_(data_language_specification)}{TUTORIAL D}. In order to make those posts self-contained and precise enough, I first need some material. This is the purpose of this essay, that could be summarized as:
 
!!{What every computer scientist should know about the relational theory}

Let me add that the material covered here is mostly inspired from what can be found in @{http://www.thethirdmanifesto.com/}{the third manifesto}, by Hugh Darwen and Chris Date. TL;DR: you should read that piece of work, really.

### The relational theory is made of _orthogonal_ layers

When I ask my colleagues or students how they would describe relational databases, it often ends up with an answer along the following lines:

!!{Well, hum... Relational databases are made of tables that contain records. Tables may also refer to each other through foreign keys. The SQL language allows querying that data, such as selecting records based on the primary key or joining tables along foreign keys.}

This is a pity. Not because it is wrong; I mean, it actually corresponds to a reality with most of the SQL products available today. It is a pity because with such a poor vision of database theory in the computer field, there is absolutely no chance that the database stuff will evolve in a good direction in the next decades. You certainly know this maxim _"those who cannot remember the past are condemned to repeat it"_, don't you? Well, it has an interresting  corollary, namely _"those who made important breakthroughs knew how the previous stuff worked"_. To be completely fair, however, it should be rephrased here as _"[...] how the previous stuff was supposed to work"_.

Let me now share a personal answer to the question above _"how would you describe relational databases?"_. Facing this question, I would probably say something along the following lines:

!!{Well, hum. Relational databases are a rather opinionated way of organizing and managing data through relations. I must immediately add that, strictly speaking, the relational theory only prescribes how data should be managed from a *logical* point of view. In other words, it prescribes how *users* should see, organize and manipulate data, in contrast to how data is *physically* organized and indexed on disks, or even distributed among different *computers*.

Now, I've said "rather opinionated" above but it should not be ill-interpreted. The relational stuff can actually be decomposed in three layers: a theory of data types (including the notion of relation), the relational algebra, and rules for relational databases. 

The first two, type theory and relational algebra, actually define formal material and could hardly be considered opinionated. I mean, it does not really make sense of criticizing arithmetic or graph theory. It may make sense to argue about the adequacy of a specific set of equations to model economic laws, but it does not make sense of rejecting the concept of an equation itself. 

The same applies to relational theory. A relation, for example, can be seen as a powerful data-structure (loosely speaking here). Relations are powerful because they come with numerous awesome operators that together form the relational algebra. In the context of relational databases, this algebra yields the database query language (for completeness, I must add that SQL is actually a calculus, not an algebra; the difference is not crucial here). Now, observe that this part of the relational theory is actually orthogonal to databases themselves. I mean, you can use relations and the relational algebra outside of any database context. That is what maths are for, definitely.

Now, relational databases. Mostly the so-called 'information principle': "*all information in the database should be represented (at the logical level) in only one way, namely, relations*". This is opinionated, in the sense that the adequacy of such a rule for effective data management might be argued. Other important rules for relational databases include @{logical_data_independence}{logical data independence}, physical data independence and integrity independence (leading to the concept of foreign key, among others integrity concepts). 

Those rules are opinionated and sometimes lead to intense debates, even withing the relational community itself. The adequate treatment of unknown information (NULL), and what form a sound set of rules for updating views are mostly open issues, for instance. Now, those issues are somewhat independent of the relational theory itself. I mean, discarding an imperfect drug has never killed a disease.}

I confess that it is a very abstract answer, probably representative of the huge gap that exists between theory and practice in database management. This is a pity, trust me. The logical level envisionned by relational logicians is a pure beauty, that makes data management truly accessible to users and raises exciting research and development issues. I wish those awesome talented developers would know, understand and embrace the logical level, instead of @{http://37signals.com/svn/posts/3045-top-tier-this}{rejecting formal education as a whole}. Computers were born from @{http://en.wikipedia.org/wiki/John_von_Neumann}{the meeting between maths and engineering practices}. We definitely need to reconciliate logicians and developers, especially in the database field.

Let me close the first part of this essay with a claim.

!!{At the logical level, database migrations should be reduced to the
assignment of relation values to relation variables.}

In order to explain the meaning of this claim, I'll have to complement this essay with something a bit more concrete. It will be the purpose of the next post.
