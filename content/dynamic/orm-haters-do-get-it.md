--- 
title: (Some) ORM Haters Do Get It
short: ORM Haters Do Get It
date: 2012-05-13 11:40:00 +01:00
category: Databases
keywords: 
- oblect relational mapping
- database
- relational theory
- relational model
- information systems
---
> This post continues the recent discussion in ORM-related posts such as @{http://www.javacodegeeks.com/2012/05/orm-haters-dont-get-it.html}{this one} or @{http://martinfowler.com/bliki/OrmHate.html}{that one}. I'm not particularly happy to participate to this very old flame war. However, I recently discovered that some developers (clearly not the authors of the posts mentioned) are simply not aware **at all** of certain ORM weaknesses, such as the huge number of queries that their naïve use may generate to the database.

> My original motivation in writing this was actually to write some high-level material for the latter developers. That happened exactly the same day the first post above appeared on hacker news. In my personal reasoning about all of this, I ended up with this post. As it provides some background that is generally missing in the discussion, I decided to publish it here.

Object-Relational Mappers (ORMs) are a strange beast. They tend to strongly divide the software engineering community. So called "haters" complain that ORMs are slow, generate huge amounts of inefficient queries, make migrations more difficult than necessary, etc. Defenders respond to the haters that they misuse ORMs and write naïve mappings and algorithms.

I would not consider myself an ORM hater, at least not one of those described above. The reason for that is simply that I don't use ORMs at all. Therefore, I don't experience those issues in the first place. But I hate ORMs, certainly. I hate them because, in my opinion, they are the epitome of bad computer science. I leave this claim unsubstantiated for now. If you are interested to know why I make such a claim, I'll explain it in another post. Here I'd simply like to explain why, in my opinion:

> You simply **can't** use an ORM the **right** way

You can use them in the _intended_ way but unfortunately there is no _right_ way. The reason is that the ORM approach is intrinsically flawed. This is the claim I'd like to discuss today.

You've probably heard about the so called _impedence mismatch_. This term denotes the difficulty to reconcile the Object and Relational approaches to data management, that is, to reconcile tables with classes, records with objects, classes with SQL data types, and so on. This is the overall objective of Object Relational Mappers.

The fact is that there is another kind of mismatch that very few developers actually know about, one that almost no one is talking about. That mismatch is about the way both sides _reason_ at the logical level. 

## The Object-Oriented way of thinking

On the object side, the developer reasons in terms of individuals. Here, "individuals" do not denote human beings, but _distinguishable things_ instead: *this* user, *that* order, *this* subscription, *that* product, *this* book, etc. Almost every ORM feature actually targets individuals, also called _objects_ or _instances_. An ORM helps you creating or destroying objects, one by one; you can observe them individually; use specific callbacks for reacting to specific events of their personal lifecycle; etc. 

This is the "object-oriented way of thinking", that tells you to write algorithms like this:

#<{ruby}{
for each individual i of interest     # dedicated ORM construct needed here
  if i.meets_some_condition
    i.do_some_task
  end
end
}

In object-oriented programming, you are talking to individual objects; it is often said that method calls correspond to messages being sent to the objects. Methods such as `meets_some_condition` and `do_some_task` may correspond to attribute getters and simple updating tasks, respectively. However, they usualy encapsulate conditions and tasks of greater complexity. In such cases, they capture some business tasks and rules and commonly involve many other objects, iterations, conditions, and so on.

For instance, `meets_some_condition` might encapsulate the following business logic:

* The order `i` contains at least 10 products
* The loan `i` is two weeks late and the book not borrowed by a library employee
* The user information includes a facebook or a twitter profile

ORM experts will tell you that the algorithm above might be better written as follows, especially when `meets_some_condition` corresponds to a non trivial condition (that is, it does not correspond to a single attribute or getter):

#<{ruby}{
for each i SUCH THAT i.meets_some_condition     # ORM special construct
  i.do_some_task
end
}

Almost all ORMs provide such a "`for each ... such that ...`" construct. Using it is better because it tends to iterate only objects of interest for the task at hand and, more importantly, it generates far fewer queries to the database (it is left as an exercise to the reader to check this claim). In the ruby on rails community, for example, not using such higher-level construct is @{http://www.mikeperham.com/2012/05/05/five-common-rails-mistakes/}{considered a common mistake}.

The reason why the second algorithm generates fewer queries is that the "`for each ... such that ...`" can usually be translated to SQL by the ORM. This is of course smarter than relying on an `if` in the object oriented language, that tend to generate a new query for each non trivial `meets_some_condition` on individuals.

Unfortunately, even with such "better" ways, you still end up thinking in terms of individuals (`do_some_task` is still sent to each individual of interest). This is the "object way of thinking", you cannot escape this without repudiating object oriented programming itself. We'll come back to this point a bit later, when analyzing a further improvement of the example above.

## What you **need** to understand is that

> The relational model, and hence, relational databases are NOT about individuals. By intent.

Knowing this fact, how could you expect an ORM to be used or written the "right way"? You cannot write a tool that reconcile two antagonistic ways of reasoning. Antagonisms cannot be resolved the "right way". That's it. 

Now, let me discuss the relational side a little further. 

## The Relational way of thinking

First, a relational database is not about individuals because a database usually captures _information_ about the world, not the world itself and certainly not its individuals. This is a very important distinction, maybe not a very subtle one, but an important one nevertheless. Don't you think that there is a very good reason why the word _information_ is a _mass noun_ in english? Because _information_ is NOT individuals, it is at best _about_ individuals. Of course, you can "isolate" a very specific piece of the whole mass of information you have, but it does not make it an individual and thinking in such term is therefore flawed at the root.

Moreover, do you know why Edgar F. Codd invented the relational model in the first place? Codd worked for IBM at that time. He had observed developers spending a lot of their time writing error-prone programs for manipulating individuals through specific information access paths. At that time, individuals were closer to pointers than objects are; and "access paths" were imperative algorithms, iterations, pointer following and dereferencing, as well as conditions for navigating hierarchical structures mapped to physical files.

Codd argued that it was better to reason in terms of _sets_ instead of individuals. And to have a _declarative_ language for manipulating them instead of a procedural one. Reasoning in terms of sets allows manipulating many records (_tuples_ would be a better name here) as simply as manipulating a single record. A declarative language decouples the manipulation _intent_ from the effective _algorithm_. Such decoupling allows one to optimise the manipulation process since automated reasoning about its intent is made possible. The optimisation may also be performed automatically instead of relying on the developer's goodwill.

To further explain the _set at a time_ approach, consider the `meets_some_condition` predicate once again. In relational reasoning, that predicate must be understood as _partitioning_ the initial set of tuples into two disjoint subsets. The way this partitioning is performed is hidden from the user at the logical level. In **declarative** SQL terms:

#<{sql}{
SELECT ... FROM ... WHERE meets_some_condition
}

## Back to the example

Let us now get back to the example above. In particular to the "optimisation" process that led to the second version with a "`for each i  ... such that ...`". The second form is much smarter because an imperative algorithm has been translated (somewhat under the cover) to a declarative intent. As a result, that declarative intent can be translated to SQL (a declarative language itself) by the ORM. The net effect is that the queries generated to evaluate the "`if i.meets_some_condition` on each individual have been trimmed in the process. 

In other words, a naïve iteration has been replaced by a smarter one. This is a typical optimisation process... that developers must take care of doing manually by avoiding the `if` construction. More precisely, by moving the `if` construct from the hosting language (ruby or java, for instance) to the query language (the special ORM construct for creating queries, which must logically be seen as a distinct language).

Further optimisations can of course be performed. For instance, let's assume that `i.do_some_task` simply updates `i`'s attributes, or creates an instance of another class, that is, "creates" an individual. In such cases (which are really common in practice), why not try to avoid an explicit iteration? Let `n` denote the number of individuals meeting the condition. The original algorithm generates `n+1` queries:

#<{ruby}{
for each i SUCH THAT i.meets_some_condition
  i.do_some_task    # one update/insert query for each `i`
end
}

Why not having an optimised version that generates only one query?

#<{ruby}{
update every `i` SUCH THAT i.meets_some_condition
}

And indeed, ORMs usually provide such higher-level constructs as well. And not using them is @{http://www.mikeperham.com/2012/05/05/five-common-rails-mistakes/}{considered a common mistake}. 

Congratulations to ORM developers then for providing such constructs! You're reinventing the wheel. More precisely, you are in the process of rediscovering Codd's original motivation. But you are 40 years late. The ORM state of affairs has a different taste than the original CODASYL background, of course, but seems very similar to me, don't you agree?

If you continue with the same reasoning, you'll end up avoiding all work on individuals. For example, you'll want to merge the `do_some_task` code upstream, because it contains another iteration that contains another condition, and so on. But in doing so, you will simply observe that it leads to rejecting object oriented programming in the first place. That is, it is strictly incompatible with the wish to have an object model for capturing data (observe that I don't reject object oriented programming as a whole but only for representing data). Object oriented programming IS about individuals.

For another example of such OO repudiation, observe that in Ruby on Rails' ORM (namely ActiveRecord), the above "`update ... such that`" feature is strictly incompatible with update callbacks. The latter are not activated when performing mass updates. In other words, either you apply the object-oriented way of thinking at the cost of flooding your database with queries. Or you preserve your database, at the cost of you're object-oriented way of thinking.

## Conclusion

I hope that you better understand the antagonism at hand here (otherwise, you might want to read the post once more). And that you're now convinced that ORMs should be avoided because they can't success in the long run. And, I certainly hope that the next time you, ORM users, will decide to write blog posts telling other developers how slow the relational model, SQL databases, JOINs or normalized schemas are, you'll favour sentences such as:

> Given that I use an ORM, which (now) I know is completely incompatible with relational databases by design, I encounter performance issues, ...

instead of any other form that would invite people thinking that the problem is intrinsic to the relational theory itself. In particular, I hope that you will now admit that in

> Generating 100.000 queries involving a JOIN is slow

the inefficient part is probably the 100.000 (linear), not the JOIN itself (constant). And that denormalizing is such cases is just a wrong answer to a real performance problem. Try sending one query instead, even if it contains a JOIN ;-)

Also, I hope that the next time you'll be tempted to finish your prose with something like

> You don't know what you are talking about.

You'll take the necessary time to ask yourself whether it is not the other way round. 
