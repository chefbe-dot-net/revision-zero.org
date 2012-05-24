--- 
title: About the Object Model
short: About the Object Model
date: 2012-05-23 17:47:00 +01:00
category: Databases
keywords: 
- oblect relational mapping
- database
- relational model
- object model
- information systems
---
My previous post, @{orm-haters-do-get-it}{(Some) ORM Haters Do Get It}, received a lot of attention and generated many comments, that belong to three main categories:

* Obviously true, but completely out of scope: _You're such a bastard!_
* Obvisouly false: _Your post suggests that we should go back to SQL for trivial queries._
* Obvisouly null, if that might be: _Use the right tool for the job._

More seriously (and fortunately), I also received many interesting comments. They acknowledge good arguments, reveal possible shortcuts and/or simplifications, explain or discuss some arguments and/or background, trigger critical thinking and so on. One of them, @{http://news.ycombinator.com/item?id=3971549}{on hacker news}, shared the following opinion:

> The divide is fundamentally about choosing what's in charge of your system, being composed of your databases, your applications, and your supporting infrastructure. 

> To relational database folk [...] the central authority is the database [...]

> The side that argues for ORM has chosen the application, the codebase, to be in charge. [...]

I agree with that comment. I also relate it to the recent @{http://blog.8thlight.com/uncle-bob/2012/05/15/NODB.html}{_"No DB"_ post by Uncle Bob Martin}. That post ends with the following thought-provoking sentence:

> The database is just a detail that you don’t need to figure out right away.

It might be surprising, but I agree with Uncle Bob as well. Of course, stated as _No database at all_, the argument does not make sense for most softwares. But understood as _Not a database-centric architecture_, it certainly does. I'm perfectly fine with provoking sentences and extreme opinions that emphasize the primary line of argument. (Also note that this blog, for instance, has no other underlying database that the file system itself; I'm not that addicted to relational databases).

Initially, I wanted to discuss the link between the two opinions above in more depth. I definitely think that reconciling relational and object-oriented programming is a particular case of reconciling data with code and that most of it has still to be done (since I reject ORMs as a solution). After two unsuccessful attempts, I gave up writing that post. I need to clarify my thoughts first.

Therefore, instead of writing an essay with lots of certitudes (such as the previous one), I decided to write one with doubts instead. Don't misunderstand. I'm a relational evangelist, and I certainly won't take a completely different line. That does not mean that I don't apply critical thinking. But enough preliminaries.

## My claim in the @{/orm-haters-do-get-it}{previous ORM post}

Some readers got it right. The previous post is not about rejecting ORMs _per se_. It is about rejecting ORMs, as a consequence of the two following arguments:

* Declarative set-oriented data manipulation is strongly preferable to one-record-at-a-time operations.
* Object orientation targets individuals, which entails a one-object-at-a-time way of thinking.

At the heart of my critics, therefore, is the use of an object model for capturing and manipulating data. In this post, I'd like to discuss where do my fear and doubts come from with respect to such object models. The following sub-sections can be read in any order, you can even skip those that don't interest you. Each of them contains questions, that you are kindly invited to further discuss if of interest. Just drop me a comment/email if you write a follow-up somewhere on the web.

## Fat model and software architecture

Let me start with a first strong claim (which is, in fact, a question/doubt).

> Q1. If you use an ORM, you must have a kind of object-model-data-centric architecture (?)

Let me elaborate a bit. In MVC (web) applications, we want to @{http://my.safaribooksonline.com/book/web-development/ruby/9780321620293/controllers/ch04lev1sec2}{avoid} @{http://blog.falkayn.com/2009/02/fat-controller-must-die.html}{fat} @{http://codebetter.com/iancooper/2008/12/03/the-fat-controller/}{controllers}, that is, we favor @{http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model}{skinny controllers} at the cost of @{http://www.sitepoint.com/10-ruby-on-rails-best-practices/}{fat models}. A fat model certainly drives the software architecture (?). I would be tempted to relate this to Uncle Bob's claim. 

> I don't want a data(base)-centric software architecture; certainly not one that strongly favors one-record-at-a-time operations; certainly not one that forces high-level software operations to be strongly anchored on particular classes and thus, tight to particular instances.

So, what do you think? How do you avoid those traps? How do you decide what operation to anchor to the object model and what operation to anchor somewhere else? What / where is this "somewhere else"?

## Conceptual vs. logical data models

Once upon a time (that is, before object-oriented programming), people made a difference between the conceptual and the logical data models. In short, the conceptual data model (entity-relationship, for instance) was translated by a software analyst to a logical data model (typically a relational database schema) following well documented conversion rules. 

That translation task is not an accident. It corresponds to crossing the boundary between the _world_ and the _machine_, a very important logical boundary @{http://users.mct.open.ac.uk/mj665/icse17kn.pdf}{emphasized by Michael Jackson's work} in requirements engineering (you should stop you reading here and read that paper now). 

In the case at hand, the boundary is between _understanding the world_ and _implementing the machine's data vision of that world_. The above translation task is the natural place to:

* Identify natural identifiers that _exist_ in the world but are _needed_ by the machine to distinguish world individuals and/or _enforced_ by the machine for preserving data integrity,
* Reason about so called _weak entities_, whose existence in the world only makes sense provided the existence of a "parent" entity, a fact translated in terms of composite keys in the machine (weak entities and composite keys, in passing, naturally help avoiding huge number of joins; just saying...),
* Decide how user requests, individually issued in the world, will be handled by the machine, that is, either on an individual or a batch/set basis.

This task is still achieved, and even automated with certain ORMs, when translating object models to SQL schemas. But there is a shift of perspective here, because it seems to operate like a compiler: from a high-level object model (used by the application) to a lower-level SQL one (hidden to the application). That shift of perspective seems wrong to me, certainly if you consider the respective imperative vs. declarative nature of the languages involved, as I already mentionned.

> Q2. Now that an entire software industry translates conceptual object models directly to object-oriented code, is this critical reasoning still applied?

Are those distinctions unnecessary by now? Are the machines now able to capture the world itself? May a world _simulation_ replace the machine's work? Or may one systematically _project_ the machine's work on a structural representation of the world entities, that is, as methods of the object model? Those questions are more philosophical, but they puzzle me.

## Normalization and update anomalies

You probably know that the relational theory comes with so called normal forms (1NF, 2NF, 3NF, BCNF, etc.) and normalization rules. To my knowledge such rules do not have any equivalent for object models. Great, we no longer have to burden with database schema normalization :-)

Normalization aims at suppressing data redundancy. The underlying objective is to avoid update anomalies. In other words, it relies on the assumption that capturing the same information in redundant ways makes the implementation of update operations error-prone and therefore dangerous. Without normalization, the developer must make sure to update all redundant places in a consistent way. Otherwise, serious software bugs eventually appear.

This problem is not specific to relational databases. In my experience, cycles quickly appear in object models. Unless you keep a strong distinction between base and derived associations, chances are that those cycles lead to unnormalized SQL schemas (when translated by the ORM for example), thus to redundant information. Redundancy also appears when developers _denormalize_ on intent, for performance reasons (as they say).

Maybe the good old assumption that redundancy is bad has changed. Storage constraints have been relaxed for a while so that redundancy is no longer a problem. The same applies to extra updates, given the computation power and disk speeds we now have.

Relaxing good old assumptions happens. At its heart, for instance, eXtreme Programming makes a bet:

> The assumption that the cost of software changes increases in an exponential way with time can be made wrong if we embrace change at the heart of the software process. 

Maybe, something similar applies to data redundancy?

> Q3. How do you tackle data redundancy and update anomalies in your projects?

Do you make a strong distinction between base and derived associations in object models? If yes, how do you enforce them in your code? Do you normalize object models? Do you control redundancy in a systematic way? Do you apply BDD/TDD and write specific regression tests to avoid update anomalies?

## Conclusion

I have still a ton of philosophico-theorico-pratico arguments and reasons that make me strongly doubt that an object model provides us with a good level of abstraction for reconciling the structural (data) and behavioral (operations) dimensions of our software systems, as we distinguish them in requirements engineering. However, this essay is already very long and not of a terrific interest, so I stop here.

Some readers of the previous post have asked for the tools and techniques I use in practice, if not an ORM. Well, I certainly don't have a silver bullet. I have @{https://github.com/blambeau/alf}{some} @{https://github.com/blambeau/dbagile}{prototypes} that help avoiding ORMs in practice. Also ideas. I hope to find the time to write about them and experiment a little in the next weeks.

* Why not having an operation-driven architecture, for instance? Organizing classes around high-level software operations (in the KAOS sense, @{http://en.wikipedia.org/wiki/KAOS_(software_development)}{a requirements engineering} method), in a real, orthogonal way to the data model.
* Why don't we have data-oriented polymorphism in relational databases? Considering functions as first-class citizens, for attribute values? "`SELECT x() FROM...`" where `x` is an attribute value, defined on a _function_ data type.

These are just some of my weird ideas (maybe not good ones) on the way to reconcile programming and databases because both worlds deserve sharing their good parts. Among them is certainly *functional* programming, which is much compatible with _relational_ databases, for example.

Now, don't misunderstand me. At the end, _**you**_ are in charge or _**your**_ software and therefore, _**you**_ use _**your**_ right tool for _**your**_ job. When you take a particular situation into account, that certainly makes sense. We are here talking about _abstractions_, which are at the heart of software engineering and computer science. I'm only wondering here what abstractions are good for what purpose. That's part of _**my**_ job.
