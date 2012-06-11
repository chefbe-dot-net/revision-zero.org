--- 
title: NoSQL is No Silver Bullet
short: NoSQL is No Silver Bullet
date: 2012-06-10 11:43:00 +01:00
category: Databases
keywords: 
- database
- no silver bullet
- NoSQL
- relational model
---
You known the "No Silver Bullet" expression, borrowed from @{http://people.eecs.ku.edu/~saiedian/Teaching/Sp08/816/Papers/Background-Papers/no-silver-bullet.pdf}{Fred Brooks' classical essay} in sofware engineering. In his paper, Brooks argues that software engineering difficulties are either _essential_ or _accidental_. Essential difficulties are intrinsic to the software construction task; they are therefore very hard to tackle or remove. Accidental difficulties are artificial barriers that can be removed with better technologies and tools. Provided that 9/10 of the engineering effort is actually spent tackling accidental difficulties, there is very little hope for an important gain in productivity thanks to new technologies, hence _no silver bullet_ for killing the software engineering werewolf.

Well known. Yet, what is true in software engineering is also true in database management. Surprinsingly however, every new database technology comes with the hope that a silver bullet has been found, one that will eventually make data management trivial. Such hope was present when people predicted the advent of Object-Oriented and XML databases a few years ago; in my opinion, it also underlies many writings about NoSQL databases nowadays.

For instance, a @{http://www.computerworld.com/s/article/9227858/The_time_for_NoSQL_standards_is_now}{recent paper on computer world} predicts the end of the relational era and the time of NoSQL as the stuff of the Internet age. Accoding to his author, the only missing piece for achieving such dream is a standard query language. The following quote is very representative of the hope for a silver bullet in database management:

> We need databases that do not require us to flatten the data and force it into a structure that the application must transform to use. We need databases that can handle today's massive data storage across as many disks as necessary to meet our needs for immediate gratification.

I'm not a opponent of NoSQL. Quite the contrary, I'm very happy to see the database field gaining a lot of interest, offering new technologies, being a renewed source of interesting ideas, critical thinking about ACID needs, etc. This is great and exciting; the NoSQL movement must be thanked for that, and hopefully will.

But we must be more careful. Their is no hope and no place for 'immediate gratification', thanks to one-to-one mappings that no longer require transforming data. This is denying the essence of data management itself. Before getting back to that essence however, let briefly analyze accidental barriers recently removed in the data management field.

## Some accidental difficulties

Many issues have been tackled in the recent years. Most of them are accidental difficulties. Making data management easier and smoother by suppressing unnecessary issues along those lines certainly makes sense. In a spirit similar to Fred Brook's argument, however, I argue that those advances are not sufficient for hoping a significant gain in data management in the next decade.

* XML, then YAML and JSON, gave us data formats that are both human-readable and machine readable. That makes sharing data between humans, computers, operating systems and softwares much easier than before. 

These data formats suppress an accidental difficulty, which is great. As we learned with XML, however, building a powerful database on the sole basis of a portable data format is probably a bit short.

* Object-Oriented databases and Object-Relational Mapping tackle the so-called impedence mistmatch. They mask the differences that exist between the databases and the programming languages and/or programming frameworks that we use. Those differences are in terms of available data types, query syntax, schema definition, database migration, and so on.

That might appear surprising, but those differences are purely accidental as well. We can mitigate their effects in many ways. A great effort has even been observed in the last decade, with lots of tools that make database management and evolution less painful. Did it make data management much easier? Not really.

* NoSQL databases tackle another huge set of of difficulties: replication, scalability, query distribution, ease of use, interoperability, schema flexibility, and so on.

The NoSQL field is very young and it would therefore be adventurous and direspectful to argue that the movement only tackles artifical issues. However, imagine a second that all remaining technical barriers for the features above can be removed. Let even imagine that a given NoSQL product ships with the perfect set of features, whatever that might be. Or that a set of products, used jointly, let you achieve such dream. Will it make you data management work much easier, really?

## The essence of data management

In my opinion, the real difficulty of data management lies at a higher level. I would summarize it as follows:

> All the pieces of information that a software collects through its various interfaces are interdependent. If some correlation is still unknown or unused, be patient, it will eventually.

The essence of data management is to bring sufficient order in the gigabytes of information we collect to guarantee that all requirements can be fulfilled in an simple and accurate way, even our future requirements. Achieving this requires theoretical frameworks for reasoning about collected data and the information it captures, and a very high transformational power, much beyond aggregations, to compute what has to be computed in order to fulfil those requirements. This is the essence of data management, period.

## Looking at the horizon

Given that, you certainly understand why the one-to-one mapping that looks so appealing when the software is young and its requirements not too numerous will shortly become a nightmare. The way you store your data is certainly optimal for current requirements, but will it remain so, even in the middle run?

Complaining about the need for your application to transform its data is also a non-sense. Managing data *is* about transforming data, in many various ways. Be prepared for it or your life will shortly become a nightmare. Go beyond accepting that, insist from your prefered database vendor to provide a data transformational tool, require a very efficient one, declarative if possible, with an optimizer... and learn using it. That will make your job much easier, I promise.

Now, look. Is there any database proposal that makes data management easier along its essence? Is there any new database that comes with a theory of data that allows you to better reason about the various co-related views? One that allows the software to manage those numerous different views in an efficient and consistent way? Or helps building those views easily, thanks to a powerful transformational tool? One that revisits normalization theory, or provides insights about how to manage observable and/or uncontrolled redundancy?

We live exciting days, for sure. Very soon, softwares will have polyglot persistence, that is, collected data will be spread over different databases, in different technologies. They will also partly or completely relax consistency and other properties. This is great and exciting. Will it make data management easier? How can one argue that relaxing simplifying assumptions provides easiness and simplicity? Is this an application of the *divide-and-conquer* principle, or quite the contrary?

Let me now make a prediction in my turn. Talking about data management, the next decade won't be easy at all. The contributions made by the NoSQL movement are already sufficient and valuable to have a deep impact on the field. Far from simplifying the field, they will make it much more complex, requiring very skilled people to avoid falling in various polyglot traps. Let's hope that the inevitable bugs won't have serious consequences, and that practitioners, researchers, schools and universities will together build the necessary knowledge to bring back some order.

## Conclusion

My followers will probably better understand my recent tweet:

> We need databases that require us to reason about what we capture and help us normalizing it into structures that prove easy to transform.

In the light of the essence of data management, let me quote Fred Brooks once again:

> As we look to the horizon of a decade hence, we see no silver bullet. 

