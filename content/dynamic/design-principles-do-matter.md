--- 
title: Design principles do matter
short: Design principles do matter
date: 2013-01-28 08:28:00 +01:00
category: Software engineering
keywords: 
- Software engineering
- Architecture
- Software process
- Agile methods
- Design principles
---

I've had a stormy discussion with other developers recently and wanted to state some principles I definitely believe in. The discussion started about a feature currently on my TODO list:

> \- Hey, did you already implement feature #65?

> \- Not yet. But speaking about #65, I really wonder whether we should not avoid that feature. [...] The strong coupling it would introduce between those two components is probably worth avoiding. In my opinion, the current API allows achieving the underlying goal in a more stable way.

Whether I am right or wrong about the coupling issue is not what's important. The fact is that another developer joined and the discussion continued, with a slightly different scope: no longer about #65, but about change, about coupling, about software engineering.

Suddently, I've heard probably the worst argument ever about how to react to change:

> We're a startup here, the business is unclear, our requirements change all the time. We don't care about that part of the API being unstable. It will certainly change either way.

You know what? The guy is right, their business is unclear and their requirements change all the time. They don't care about (certain) APIs being unstable. They will certainly change them either way. Fine.

I really start wondering if this is not a consequence of agile methods being ill-understood by most. Kent Beck convinced you all, isn't? *Requirements change all the time*. He is true. This is **not** an excuse for avoiding requirements analysis completely, this is **not** an excuse for skipping good design, this is **not** an excuse for building shit, damned!

Your business is unclear? Make it clearer. Your requirements change all the time? Write them anyway. Your APIs change often? Stabilize them. Your process is a mess? Fix it, now.

I said *ill-understood* agile methods above, and I persist. I do not consider myself an agile advocate, but I know @{http://agilemanifesto.org/principles.html}{their principles} at least:

> Continuous attention to technical excellence and good design enhances agility.

Good design does matter. Design principles do matter. Requirements analysis does matter. Requirements analysis principles do matter.

## It's all about principles

Do you know why principles exist in the first place? Because we are imperfect. We fail at thinking clearly most of the time. We fail at creating bug-free softwares. We fail at modifying them without making them worse. We fail at almost everything in this live and this is why we state principles. To help us avoiding failures when possible, and accepting them pacefully the rest of the time.

It probably looks arrogant, isn't? (stay tuned, I will do worse in a minute). In certain circles, agile advocates also are judged arrogant. In my opinion, there is a slight contradiction hidden here: we are arrogant but in a humble way (sic).

Take test-driven development. This is probably the most known of all agile techniques and principles. Those arrogant consultants will tell you: 

> \- 100% coverage, bastards, otherwise you're not agile!

Maybe you didn't notice yet. Test-driven development has a very humble foundation. Those that @{http://blog.8thlight.com/uncle-bob/2012/01/11/Flipping-the-Bit.html}{flipped the bit} recognize that they commonly fail at implementing bug-free features. They accept that they **need** tests. They know that their coverage is not sufficient, but they pacefully accept it. This is humble, not arrogant (and yet that sentence is of uttermost arrogance).

## Design principles do matter

Anyway, agile methods are mostly about *process principles* (being slightly simplistic here), all good principles. But process principles are not enough. One also needs requirements principles, design principles, data management principles, maintenance principles, human principles, etc. 

My story above is about *weak coupling*. This post about software design principles specifically. Among them:

> Weak coupling, cohesion, logical vs. physical, conceptual integrity, information hiding, data integrity, versioning policy, soundness, separation of concerns, data independence, maintainability, specification vs. implementation, simplicity, public vs. private, black-boxes, robustness, thread-safety, precision, controlled redundancy, reusability...

All those principles matter. All of them help you avoiding failures when possible, and accepting them pacefully the rest of the time.

I will make a favor here: you may reject those principles (even data integrity, I swear), but you may not *ignore* them. You MUST know them, all of them. And then, you'll have the opportunity to reject them in specific situations. Don't get it wrong. When the time comes for one of your software components to actively reject a design principle, let the component announce it clearly and loudly:

> This method is **NOT** robust. Please check its preconditions.

> I'm **STRONGLY** coupled with XXX. Do **NOT** change XXX without changing me.

> XXX is **STRONGLY** coupled with me. Do **NOT** change me without changing it.

> This class is **NOT** thread-safe.

If rejection is your choice, this is probably the best you can do, but be prepared for trouble. Having a good process and applying good design are effective ways for avoiding a mess. You've been warned.

## What if you don't know them?

Maybe you simply don't know about requirements principles, about design principles, about data management principles. Most developers simply don't. I must confess having a serious lack of knowledge about good UI principles, about security principles, about human management principles, etc., etc., etc. We can't know everything and that's fortunate. Most of the time, lack of knowledge also allows us to pacefully ignore our failures. @{http://harthur.wordpress.com/2013/01/24/771/}{Until someone that knows arrogantly comments}. 

So what if you fail without even knowing it? What if, for example, certain forms of coupling are too subtle for object-oriented tips and tricks to effectively work. What if in the real world the @{http://en.wikipedia.org/wiki/Law_of_Demeter}{Law of Demeter} and @{http://en.wikipedia.org/wiki/Single_responsibility_principle}{Single responsibility principle} give absolutely no guarantee?

Well, if your software is safety critical, please let me know where not to stay. If it is not, keep calm. You are probably losing a lot of your time and money changing your software much too often but that's fine. You know,

> You're a startup, your business is unclear, your requirements change all the time. You don't care about that part of the API being unstable. It will certainly change either way.

## What if you want to improve?

Unfortunately, I don't know a book that lists all important design principles. I promise, I'll write it one day but I must first learn about all the design principles I don't know and that's probably a lot.

In the mean time, I suggest you to fail. And to fail again. And to fail again. My experience teaching requirements engineering, data management principles, design patterns and design principles at the university has strongly convinced me about one thing. As a student, I was much too young. My students today are much too young. They strongly lack experience and the university won't give it to them. They still have to fail and I hope that they will, as I have. I hope that the university will improve its ability to provide them with opportunities to fail, not the other way round.

If you're currently engaged in a software development team but failure is not an option, then you can start stating a few software principles. Take simple ones first:

> Every component should have a suggestive name. And a version number. And that version number should have a semantics. Every component should have a single and simple function, a single role in the whole software if you want. And it should follow some of the principles listed above. It should do it in a flexible way. It should systematically track its own failures at meeting its own principles because it is the only royal road to improvement. Last but not least, it should speak clearly and loudly about the principles it actively rejects because other components won't notice otherwise.

Last but not least, if your own failures are not enough to learn, simply take mine as good counter examples.

> `Itchy` is a data component. Well, it is *almost* a data component since it also encapsulates a job queue because, you know, we needed a job queue and we already had a deployment infrastructure for `Itchy` so we decided to put the job queue there as well. But expect for the job queue, `Itchy` is a data component. Its role is to export and import data.

> `Itchy`'s version is currently 1.3.2. However, that version number must be used with care by the development team. I mean, a subset of `Itchy`'s API change often in an backward incompatible way without increasing the major version number. It's not a big deal in practice because we know that these services are only used by `Scratchy`; `Itchy`'s changes on this API subset are actually *driven* by `Scratchy`'s changes. No broken behavior should normally occur, except maybe if `Scratchy`'s javascript is kept in cache. That should not happen in principle given Apache's configuration; even it if did happen, it would only affect the software's administrators (who use `Scratchy`), and we can tell them to refresh their browser, unlike the users of the `Poochie` component that uses the other services.

> Speaking of `Poochie`, we probably made an odd decision a while back that leaks here and there. For now, data exported by `Itchy` is tagged with a `deleted` attribute that only makes sense for `Poochie`. We've implemented a filter in `Scratchy` to ignore data tagged as `deleted` and told the administrators to ignore such data if it shows up anyway.

> I don't know exactly how `Krusty` handles the `deleted` stuff. Anyway, we plan to precisely document which of `Itchy`'s services are exactly used by who. It would at least allow us to avoid messing with the version number.