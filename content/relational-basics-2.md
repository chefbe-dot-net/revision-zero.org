--- 
title: Relational Basics II
short: Relational Basics II
date: 2011-12-12 17:15:00 +01:00
category: Databases
keywords: 
- relational theory
- relational model
- database
- information principle
- relational algebra
- types
- ruby
---
After my @{relational-basics}{previous phisolophical essay}, let now turn to something a bit more concrete by discussing the logical level of relational databases. Do you remember the information principle?

> All information in a relational database should be represented at the logical level in only one way, namely, *relations*.

In other words, 

> From a logical point of view (that is the one of the database user) a database defines a collection of typed variables (≃ SQL tables). These variables contain relations as values (≃ their records).

The definitions above make use of specific terms that I would like to discuss now.

### Types and Values

Managing data certainly means being able to reason in terms of types, values, and (to a lesser extent) variables. Those concepts may seem obvious to you... great! However, it does not seem that obvious in object-oriented programming languages such as ruby, so I'd like to discuss them in more details.

> A *type* is a set of elements, called values. We say that a value 
> belongs to a type, if it is one of its elements.
> 
> Values are immutable (you can't modify the integer value '3', in any way). 
> They can be of any complexity (sounds and videos can be seen as values, for instance). 
> Values also have no location in space or in time (unlike their physical representations).

Obvious, don't you think? Booleans and Integers are common types. So are Reals, Lengths, Sizes, Temperatures, Colors, URIs, Sounds, Videos, Email addresses, Graphs, etc. Values are simply elements of those sets: true, 12, 1227.4521, 12 cm, small, 25°C, Blue, http://www.google.com/, ..., ..., blabla@rtbf.be, ..., etc.

It seems obvious to me. I hope it is obvious for you too. Then, wouldn't you expect a systematic treatment in programming languages? At least in data-driven programming languages? Let have a look at ruby for example:

#<{ruby}{1.is_a? Integer                # true
true.is_a? Boolean             # NameError: uninitialized constant Object::Boolean

String.new "hello"             # "hello"
Integer.new 1                  # NoMethodError: undefined method `new' for Integer
URI.new "http://google.com/"   # NoMethodError: undefined method `new' for URI:Module

URI.parse "http://google.com/" # <URI::HTTP:0x87b3c04 URL:http://google.com/>
Integer.parse "1"              # NoMethodError: undefined method `parse' for Integer:Class}

Data manipulation is definitely not written in ruby's genes. Does the principle of least surprise really apply here? Now, I don't want this to be misinterpreted. I *love* ruby, really; it changed my life. I've chosen ruby for this example only because it is the language I mostly use today. Things are much worse in languages such as C or Java. And even worse in SQL, which is a shame. The point is that data-manipulation (and therefore databases and database-oriented languages) requires a systematic treatment of types and values. Work remains to be done here, definitely.

Maybe you think here: _"Is this really important?"_. If you're not convinced by the ruby example above, consider the following data-manipulation exercise:

> Build a program in ruby that takes as input 1) a CSV file and 2) the type of each of its columns; the program must return true if every line is consistent with announced types, false otherwise.

For this program to be written, you'll necessarily need to bring some order in the data types proposed in ruby, and their coercion methods from strings. You'll quickly discover that ruby does not have a Boolean class, while some of the CSV columns will be announced as being booleans. You'll quickly discover that your ability to _reason_ in terms of data-types has been sacrificed in the name of the holy duck typing. Sound data manipulation is definitely not written in ruby's genes. 

> Current languages tend to think that "to be" is the same as "to behave", which is wrong.

### Tuples and Relations

The information principle requires all information in a relational database to be represented through relations. Let now make this a bit more precise:

> A relation is a set of tuples. A tuple is a set of (name, value) pairs, called attributes

So, an example of relation might be:

#<{ruby}{
(Relation 
  (Tuple address: (Uri "http://kernel.org/"), since: (Year 1997)),
  (Tuple address: (Uri "http://google.com/"), since: (Year 1997)),
  (Tuple address: (Uri "http://amazon.com/"), since: (Year 1994)))}

I've chosen a particular functional syntax here, which is compatible with ruby. This is not crucial, even if I have made it on purpose (see below). The example shows a relation that relates (sic) URIs and years with the following intended semantics: 

> (According to whois,) the domain name of the website `:address` <br/>has been registered in year `:since`

The following observations can be made on this example:

* The information captured through tuple attributes makes explicit uses of specific types. A web `:address` is an URI whereas `:since` is a Year.
* A tuple relates names to values of those types. A tuple itself is a value, namely a set. This is the reason why I've chosen the same kind of syntax for `(Tuple ...)` than for `(Year ...)`. Systematic treatment of values, I said. We also forbid tuples to have two attributes sharing the same name (which would otherwise be allowed by the definition of a set of pairs).
* A relation is a value, which is the reason why I've chosen the syntax `(Relation ...)`. A relation is a value because it is defined as a set of tuples. Being a set, a relation does never contain two tuples capturing exactly the same information, two "equal" tuples. 

In our example above, the relation contains tuples that have all the same "structure". This is not incidental, as I explain now.

### Tuple and relation types

If values are elements of a type and if tuples and relations are values, then they must also have a type. Otherwise, our mathematical framework would not be sound. To bring some soundness here, consider the following notion of _heading_:

> A heading is a set of (name, type name) pairs

For example, in our example, the following heading might be considered:

#<{ruby}{(Heading address: Uri, since: Year)}

We say that a tuple is of type `TUPLE{H}` if its attributes agree with the heading `H`. We then say that a relation is of type `RELATION{H}` if all its tuples are of type `TUPLE{H}`. To keep a consistent syntax however, we will write tuple and relation types as follows:

#<{ruby}{
(TupleType    address: Uri, since: Year)
(RelationType address: Uri, since: Year)}

As you can see, these definitions imply that a relation must have all tuples with the same structure, precisely the same heading. In other words, the following candidate is not considered a valid relation:

#<{ruby}{
(Relation 
  (Tuple foo: "hello world"),
  (Tuple bar:            17))}

It might be argued that such a mathematical framework is very restrictive, i.e. that strong typing is not a good choice and that the latter relation makes perfect sense. Well, in my opinion data-management often means bringing order to data and strong typing helps achieving this task. Beyond that, alternative frameworks might of course be considered. Keep in mind, however, that we need _sound_ frameworks allowing formal reasoning. Formal reasoning, is what allows the definition of a query language such as relational algebra, and optimizations when evaluating query expressions. I'll stick here with this mathematical framework which is a good trade-off between flexibility and rigor.

### Variables and relational databases

We now have sound notions for (rich) data types, values and relations. What is a relational database then? A collection of relations. Most precisely, a collection of relation variables.

> A variable is a placeholder for a value. Unlike values, variables have a location in time and space. Variables actually contain different values at different times.

The information principle requires a relational database to capture all information through relations only. This can be seen as restricting the kind of variables manipulated by the database. In other words, we will consider only typed variables, where types are _relation types_ exclusively. 

In its simplest form, a database _schema_ can thus be seen as definitions of relation variables:

#<{ruby}{
...
(RelationType address: Uri, since: Year) WEBSITES;
...}

A database _value_ is then defined as relation values assigned to those relation variables:

#<{ruby}{
WEBSITES = (Relation 
  (Tuple address: (Uri "http://kernel.org/"), since: (Year 1997)),
  (Tuple address: (Uri "http://google.com/"), since: (Year 1997)),
  (Tuple address: (Uri "http://amazon.com/"), since: (Year 1994)))
}

No, we have said that variables contain different values at different times. So how do we update a relational database? By affecting new values to relation variables, that's all. What about SQL's INSERT and DELETE? Semantically, just shortcuts for the affectation of a newly computed value:

#<{ruby}{
(INSERT t INTO RELVAR)  means (RELVAR = PREV_VALUE UNION (RELATION t))
(DELETE RELVAR WHERE x) means (RELVAR = PREV_VALUE MINUS (PREV_VALUE WHERE x))}

### A few consequences as thought provoking conclusion

So far so good. Isn't it a beautiful way of defining relational databases? A collection of variables that contain relation values. _Inefficient_, I hear you. Beeeeeeepp! 

You felt the trap of not distinguishing between the logical level and the physical one. The relational theory is mostly about the logical level, about the interface that we want to give to users to manipulate their data. Isn't the affectation operator above part of an awesome interface?

> At the logical level, database migrations should be reduced to the
> assignment of relation values to relation variables.

If the clojure functional programming language is @{http://blog.8thlight.com/uncle-bob/2011/12/11/The-Barbarians-are-at-the-Gates.html}{perceived by some as a good bet for the future}, isn't it because it defines a @{http://www.infoq.com/presentations/Simple-Made-Easy}{simple _logical_ interface to computation}? Clojure requires efficient algorithms and techniques at a lower level of abstraction, such as @{http://en.wikipedia.org/wiki/Persistent_data_structure}{persistent data structures}. Isn't it similar to what I'm talking about here? So, why don't we have a nice logical interface to relational databases?

A much better interface than SQL is possible. Such interface is not Object Relational Mapping (ORM), because ORMs do not provide systematic treatment of types and values. In contrast, such interface will support rich, user-defined datatypes; it will allow relations to contain any kind of values, including values of user-defined types as well as sub-relations; it will support the affectation of relation values to relation variables. 

After 40 years, much of the relational dream has still to be built, any volunteer?
