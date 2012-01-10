--- 
title: About Logical Data Independence (2)
short: Logical Data Independence II
date: 2011-03-03 17:03:00 +01:00
category: Databases
keywords: 
- database
- logical data independence
- independence
- views
---
My @{logical_data_independence}{first post about logical data independence} is by far the most popular on this blog. So I bet that writing the next part would be appreciated. Let's start by summarizing the first paper:

> Data independence means *"avoiding changes made to the data module of a software to propagate and hurt its other parts"*.

> *Physical data independence* is this concept applied to the database physical layer. This layer forms the internal specification of the database and is concerned with the following questions: where is data localized? in which encoding? are there indexes available? which kind of?

> *Logical data independence* is this concept applied to the database logical layer. This logical layer is part of the public, external specification of the database: what real-world concepts is the database talking about? how do they relate to each other? how do we query that data?

### Two kinds of change

From the definitions, distinguishing between physical and logical changes is easy: if you move your data from one place to another one, if you add an index, if you change the encoding, etc. you make a physical change. If your database offers physical data independence (which is the case with SQL databases in practice), you won't have to change too many lines of code of (the rest of) the software, if any.

In contrast, if you add a concept (in SQL terms, a table or a column for instance) or worse, if you delete, rename, split or change a concept,... you are making a logical change. If your database offers logical data independence (not so often in practice), you won't have to change too many lines of code of (the rest of) the software, if any.

Note that most authors restrict their attention to physical and logical *schema changes*. Strictly speaking, the logical (resp. physical) schema is only one part of the physical (resp. logical) layer, even if the most important one. For completeness, we should also consider other kinds of change. For instance, modifying the semantics of the logical query language (SQL, for example) is a change to the logical layer. And a non-backward compatible change would certainly hurts logical independence.

#### Aside: _What kind of database?_

I would like to stress the fact that I'm not exclusively talking about _relational databases_ here. The data independence concepts have been made clear thanks to Codd's work on the relational model, but they seem sufficiently abstract to remain relevant when considering other kinds of databases. If you know about some of the NoSQL databases that recently appeared, I strongly invite you to reason in terms of physical vs. logical layers and data independence. Note that I'm not especially advocating for or against such databases here. Nevertheless, if many NoSQL writings discuss scalability, consistency, availability and/or partition tolerance (also have a google search about what is called the @?{CAP theorem}) only @?{NoSQL data independence}{a few} propose a discussion in terms of those classical independence concepts, which are equally important.

I'll try to continue this discussion in a later post (there would be a lot to say about NoSQL, but it is not my aim in this particular post). In the meantime, I strongly invite you to conduct such a study yourself. Please drop me an email if you write something about data independence and NoSQL on your own blog. I would certainly like to read it. Thanks!

### A real-world example of logical change

In contrast to physical independence, few books give convincing examples of changes applied to the logical layer. Moreover, none that I know gives any tip or pattern for preventing such changes to propagate and hurt the rest of the software code. This is very strange in a sense because logical changes are often a consequence of software success: new features and/or enhancements of existing ones will certainly require changes to the logical database schema. Without pretending that I've found THE killer example, I've recently encountered an interesting use case on a real case study. As it is that example that initially triggered my motivation in writing this series of posts, I'd like to spend some time summarizing it here.

I've been recently involved in a IT project in a Belgian Hospital. The aim was to help introducing @?{clinical pathways}, a patient-centric organization of medical cares. During this project, we observed that an important legacy feature was the management of appointments. In short, patients are taken in charge by specialized physicians for specific analyses (consultation, scanner, blood test and so on.). The time of an appointment is often agreed in advance -- except maybe when the patient is treated in emergency -- generally during a previous appointment, or by phone.

![](images/logical_data_independence/hospital_appointments.gif)

In the hospital I was working with, this reality was captured by an <code>appointments</code> table inside a relational database, as shown in the figure above. In such a relational schema, the current state of each appointment is kept in a <code>status</code> textual field. This value of this field is updated by medical people (via specific software screens) with the occurrence of special events: the patient cancels or requests another appointment by phone, she arrives in hospital's waiting room, she enters consultation room, and so on. 

When discussing with the nurse in charge of the introduction of clinical pathways inside the hospital, we came to the conclusion that the possible values for the <code>status</code> field and their transitions could well be governed by an appointment statechart, as illustrated below. However, an early database inspection showed that the <code>status</code> field could render about 30 different values. Also, it quickly appeared that no one in the hospital could even start explaining what those 30 different values were about and how they evolved over time... 

![](images/logical_data_independence/appointment_statechart.gif)

One of the main objectives of clinical pathways is precisely to help better understanding care processes, as a step towards improving them when possible. Making so implies conducting reverse-engineering phases and, sometimes at the cost of small changes, legacy software is a wealth of information for this. In the example at hand, we wanted to be able to answer an open-ended list of questions about medical appointments. Among them:

* What do appointment statecharts look like? Are they strongly dependent of the kind of medical analysis (consultation, blood test, scanner, and so on)?
* Are appointments often cancelled? What proportion and for what reasons?
* Are all appointments planned in advance? How much time before?
* And so on

The fact is that, whatever the technical solution you would choose, answering such questions requires considering the full history of appointment statuses instead of a temporal snapshot. In other words, you cannot answer such questions if you only have the data given by the database schema above. Instead, you have to first collect data about appointment's state transitions and then hope that querying the collected data (or applying machine learning techniques, for specific questions) will reveal the answers you are looking for... 

Note that the inability to answer the questions above is _a fact_, and in full generality, that fact *does not depend* on the database technology you use, but *it does depend* on the database logical schema. In other words, even if you use a SQL / XML / Object / NoSQL or JSON database (choose the one that you prefer),... and even if that database technology comes bundled with magic features to handle temporal, i18n, or whatever kind of metadata we could consider... I'll be able to find an example of some feature you've not considered in the first place, or an example of data you've not collected. And that example could be the next thing to add to your software for achieving specific new requirements. This is precisely what _logical schema changes_ are about: a new requirement (reverse engineering statecharts in the example at hand) modifies the way you capture the world and forces you to slightly move the boundaries of your world of interest. Very often, your previous modeling window is still relevant but becomes a special case:

![](images/logical_data_independence/appointments_logical_change.gif)

Now, specific technical solutions to the problem at hand may certainly be discussed, argued, compared. Such a discussion must certainly be conducted in terms of cost, easiness, transparency, performance hit, and so on. During such an interesting debate, the logical independence argument could be summarized as follows:

> (Assuming an additional requirement, namely that your solution must provide an unified view of the data) how to implement the "historical data collecting" feature without modifying any line of code of legacy softwares deployed in the hospital?

The additional requirement mentioned between brackets, while probably arguable, is some kind of natural consequence of what logical data independence is about. I mean that fully transparent solutions exist that would not even touch either the database or legacy softwares (analyzing database logs, introducing a network sniffer, or whatever). However, such solutions have the major drawback of not providing an unified view of data. In the example, it is very likely that we'll later have to analyze historical data with respect to other concepts already present in the database (what kind of medical analysis? what disease? who is the physician? his expertise? and so on). Therefore, ensuring an uniform, query-able, logical schema of data might look like a good idea. In any case, thinking in terms of logical data independence does not really make sense if you remove this requirement (why?). Therefore and for the sake of the example, let's consider that it has to be met! In that case, and given all stated requirements, what solution would you suggest?

### Possible solutions in the RM/SQL world

The first solution I've imagined at that time is the one that I still consider the simplest and most clean (at least theoretically). It consists in doing exactly what the classical database theory would recommend: modifying the logical schema for real while ensuring a consistent view of the previous schema to legacy softwares using the database (therefore guaranteeing logical data independence). In essence, it consists in doing what is illustrated in the figure below, namely:

![](images/logical_data_independence/solution1.gif)

* Replace the old <code>appointments</code> table by a new one, <code>appointments_v2</code>, that does not have the <code>status</code> attribute anymore,
* Add a new table, <code>appointment_history</code>, that captures the evolution of the <code>status</code> attribute over time (observe the <code>since</code> temporal attribute, which is part of the primary key),
* Restore the previous logical schema via an <code>appointments</code> view. The latter computes the temporal snapshot of the previous logical schema via a projection-join of the two tables just mentioned (it is even possible to avoid a -- so called -- costly join, if you're concerned with efficiency),
* Add rules on that view to restore the semantics of inserts, deletes and updates on the previous schema in terms of the semantics of the new one (capturing this precisely requires a short analysis in practice).

This first solution is only achievable if the DBMS provides either <code>INSTEAD OF</code> rules or <code>ON INSERT/UPDATE/DELETE</code> triggers on views (that PostgreSQL provides, for example) or something semantically equivalent. Except for the initial data migration that consists in splitting the <code>appointments</code> table, implementing the requested feature takes about 25 lines of SQL and is implemented in approximately 30 minutes. Above all, it does not require any other change, nor re-compilation or re-deployment of legacy software. This is what logical data independence is about.

#### An alternative way

An alternative way is worth considering if the DBMS does not provide rules and/or triggers on views. It consist in keeping the original <code>appointments</code> table unchanged (trivially providing logical data independence, by construction) and adding <code>ON UPDATE</code> and <code>ON INSERT</code> triggers to fill an <code>appointment_history</code> table that keeps track of all updates of the <code>status</code> attribute over time.

![](images/logical_data_independence/solution2.gif)

From a theoretical point of view I'm a bit less in favor of this second solution, mainly because it involves explicit data redundancy of the appointment <code>status</code> and, as such, does not support appointment deletion without loss of data (the previous solution does). One can overcome this weakness at the cost of more complexity, more redundancy and/or more de-normalization (variations around duplicating the whole appointments table). In contrast, this solution avoids the data migration cost that would be required if the previous solution was chosen. In any case, this solution equally provides logical data independence!

#### Other solutions?

I could imagine a lot of variations around the two previous solutions, using rules, triggers, materialized views... The example considered here is representative of situations where new requirements require the introduction of a temporal dimension to some part of the existing database (a single attribute here). As you've seen, I'm in favor of tackling such a problem via the database logical schema itself for the reasons mentioned above. If you're interested in further reading about similar temporal schema issues, I strongly suggest reading "Temporal Data and the Relational Model"[1] which provides a rich and deep investigation of that topic. 

### Conclusion

In this post, I've summarized what is theoretically meant by _logical data independence_ and discussed a real-world example together with possible solutions. As shown, those solutions require support from the DBMS in terms of rules, triggers or something equivalent. More generally, 

> Logical data independence is related to the database ability to present different logical schemas at different times while providing consistency rules between them in terms of data semantics. 

Doing so allows the logical database schema to evolve in a backward compatible manner, providing truly logical independence in practice (different software modules may even see different versions of the database schema at the same time). Support for views (updatable views or something equivalent, like declarative rules, in practice), looks like a _must have_ to really achieve this. This is why I stated in my first post that, in my opinion, a database that does not provide views as first class citizens could hardly argue providing logical data independence.

Now, the applicability of proposed solutions on the problem at hand are arguable, maybe for efficiency reasons (which I bet would be the main counter-argument). Therefore I'm certainly interested in discussing or comparing with other ideas you might have (also with other database technologies that RM/SQL). However, when considering alternative solutions, remember the requirements implied by logical data independence:

* The solution has to provide an unified view of data,
* The solution may not require changing any line code of legacy applications that use the database

If these functional requirements are met it is also important to evaluate non functional requirements: easiness of the solution, applicability in practice, efficiency, maintainability, and so on. If they are not, it seems difficult to argue that the solution provides logical data independence in the first place. Of course, one might argue that sacrificing logical data independence is sometimes necessary in presence of other requirements (something similar currently happens with the NoSQL trend that tend to sacrifice consistency for scalability, for instance). This would lead to another discussion, though.

### Credits

Many thanks to Jonathan Leffler and my brother Fabre for their careful reading, friendly comments and english corrections of these posts on logical data independence. This is greatly appreciated!

### References

1. C.J. Date, Hugh Darwen and Nikos Lorentzos, _Temporal Data & the Relational Model_, Morgan Kaufmann, 2002, 1st edition, 422 pages, ISBN 1-55860-855-9.
