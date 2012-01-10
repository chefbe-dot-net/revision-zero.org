--- 
title: About independence in computer science
short: Independence ?
date: 2010-02-07 16:10:00 +01:00
category: Architecture
keywords: 
- independence
- coupling
- cohesion
- separation of concerns
- information hiding
- architecture
---
I've been talking about _logical data independence_ @{logical_data_independence}{here}, about source code independence @{book#how}{there}, and so on. It's probably time to provide some lecture about _independence_ in the large when talking about computer science.

I wanted to start this post with a quick review of google results for "computer science independence" or "software architecture independence". I have to admit that the results are not really convincing...

In my opinion, one of the major weaknesses of computer science nowadays is the lack of theoretical abstraction. For instance, good students of mine know about java interfaces, but they don't have any insight of general principles underlying the _reason of introducing interfaces_... Whatever your profile, *knowing good principles is always better than knowing practical tips and tricks !*

## What does independence mean?

Independence in computer science is both about _change_ and about _abstraction_. More precisely, _reaching independence_ means _using the good abstractions_ to allow the software not to be too much hurt by _changes_. 

## What kind of change?

Changes may be numerous and of different nature. The list below is a open-ended proposal, don't hesitate to ask questions or to start a discussion about practical examples.

* *Assumptions*. Your software always makes a lot of assumptions about its environment, some of them being implicit, others being well known and/or documented. The second are generally easy to handle... while the former are killers.
* *Requirements*. Probably the worst... changing requirements (what the software is supposed to do) often means changing the implementation in depth. How to react to changing requirements?
* *Evolution*. New features? Great! New features generally means that the software is being adopted by its users. But how to implement new features without breaking existing ones?
* *Third party*. Almost all softwares use third party libraries/tools/devices. Those components also change and these changes may affect portability/stability/robustness of your software. How to get away from third party changes?
* *Optimization*. People want softwares to act fast, and always faster. Optimizing means _changing the base code_ to handle such requests. More precisely, optimizing commonly means _changing the implementation_, in contrast to the _specification_. Optimization is unfortunately often premature, and even dangerous if it leads to breaking features. How to optimize the good way?

## Coding patterns in presence of changes

First of all, agile developers are right: *changes occur*.  You can't prevent them. Loosely speaking, there are two ways to face _changes_. The pragmatic way: _accept them and react accordingly_. The theoretical one: _anticipate changes_ with good requirements, good architecture and so on. These two approaches are *not* antagonistic. Coding patterns below are practical things (something that you apply for real), but many of them are inspired by sound principles (something more abstract that you know the merits, see next section).

### Testing

Are you already applying _test driven development_? No? *Give it a chance*... *now!* It helps you making <u>assumptions</u> explicit, thinking about <u>requirements</u>, detecting <u>third party</u> changes and not fearing major <u>optimization refactorings</u>. When I start learning a new third party library, I write tests and assert my own understanding of that library. Such sandbox tests stay alive with your software, providing a shield about third party changes and  ensure that your assumptions stay correct. Also, the first thing I do before optimizing is convincing myself that I've reach a good black box test coverage of the chunk of code I plan to refactor, by writing additional tests of course. And so on.

### Encapsulating uncertainty

When I'm not sure about something (related to <u>assumptions</u>, <u>requirements</u> and <u>third party</u>) I encapsulate my uncertainty inside a given function/class/method/package/whatever with an extremely precise (and strong) specification. Some examples: 

* The documentation of a third party method behavior is vague? Encapsulate calls to it with something stronger!
* Hesitating between interfacing with an external library, copying (open-source) code from it or re-implementing features of interest? Write a facade in front of the features you use.
* Not sure how a method is supposed to behave in a specific situation - maybe because the problem it solves is not completely specified yet? Detect the unsupported case and raise an error: for the caller, _having a strong post-condition_ (an error is raised in that case) is always better than _hoping that it will pass_.

These techniques are extremely powerful: in all cases, you *replace vagueness and uncertainty by strong certitudes*. Detecting and reacting to future changes will be a lot easier.

### Preprocessing

An important source of change is _input change_ (related to <u>requirements</u> and <u>evolution</u>). Many software modules "consume" some data and the way this data is described (i.e. data structures are used) is of critical importance. Each module should *work on a data-structure that makes its implementation easy* and intuitive. For instance, if a web page presents a big table of results, its input should be a big table of data... and if it presents a tree, its input should be a tree. Preprocessing simply means introducing data converters where needed. A counter-example: the previous table is rendered by navigating through an entire object model (typical with ORMs), following associations, making counts, etc. Such a rendering technique will be strongly hurt by changes in the object structure. Encapsulating the conversion between the object model and a big table of data inside a dedicated (and well tested) function will evolve a lot better! Even <u>optimization</u> of that function will be easier.

### Abstracting

In my opinion, the nature of computer science and the best pattern for software <u>evolution</u>. Unfortunately, this pattern is also the most difficult to use the right way and the most dangerous: abstracting too much definitely kills your software! Abstracting is difficult to define... let start with the @{http://en.wikipedia.org/wiki/Abstraction}{wikipedia definition of _abstraction_}:

> Abstraction is the process or result of generalization by reducing the information content of a concept or an observable phenomenon, typically to retain only information which is relevant for a particular purpose.

The last part of this sentence is worth reading! Let me discuss the @{book#how}{example of blog's links}. From the point of view of the blog sources (the format I use for writing these papers), a link is a pair: _identifier_ of a target location and _label_ to render:

#<{html}{%{wlang/dummy}{ Let me discuss my @{book#how}{example of blog's links} }}

This abstraction is sufficient: it encloses the relevant information for the practical purpose of what a link _is_ in the blog sources. The way theses links are "implemented" (by a _href and url_ or a _onclick and ajax_) is another story... From a development point of view, abstracting is enforcing a separation between (un)related concerns: _specification_ from _implementation details_, for instance.

## Principles underlying those coding patterns

The patterns presented before are practical coding patterns. The reason of using them is driven by theoretical concepts that are even more important. Below are four abstract concepts that drive my developer's work almost everyday:

* *Coupling* in software architecture captures the notion of dependency links between modules. Two modules are strongly coupled if the dependency link between them is so strong that changing one of them will necessary imply changing something in the second one as well. A good architecture enforces *weak coupling*. Introducing interfaces (in Java, for instance) generally means _reducing coupling_ by <u>Abstracting</u> (provided that the interface is well designed, I should add). <u>Preprocessing</u> and <u>Encapsulating uncertainty</u> patterns above also help reducing coupling a lot. 

* *Cohesion* is related to coupling. While not being wrong, it is a bit subtle. Cohesion captures the notion of _doing few, but doing it well_. Somewhat strangely, a *strong cohesion* _reduces_ coupling even if it introduces dependency links (ensuring cohesion naturally implies having more - related - modules). The explanation about this fact relies in the kind of dependency we are talking about. Let's go back to the <u>Preprocessing</u> example about rendering a result table in HTML: a template renders data, prepared by a specific function. Both have a strong cohesion, but the former depends on the second. However, the dependency link is weaker than expected: even if the data is wrong, the template may render it. As an interesting consequence, each module can be tested independently. And when both are correct, their integration is probably correct as well: the table presents accurate results. This discussion naturally leads me to the next point.

* *Separation of concerns* is the general principle underlying _problem decomposition_, where small achievements taken altogether allow a bigger one. In my experience, separation of concerns is also THE key notion to apply the <u>Abstracting</u> coding pattern the best way. Introducing abstractions without gaining along the separation of concerns may lead to an API which is  less stable, harder to understand and harder to maintain.

* *Information hiding* captures a notion of module _secret_. This is an interesting question to ask yourself when designing an architecture: what is the secret of each module? If you can't answer that question, there's probably something wrong in the decomposition. Think about the _Encapsulate uncertainty_, _Preprocessing_ and (though somewhat less) _Abstracting_ coding patterns: all of them force encapsulating "design choices" (which external library? where does the data come from? how is a link actually rendered in an HTML page? and so on.) in specific places; in other words, all of them introduce secrets, all of them help reaching *strong information hiding*.

There is something really nice these four theoretical principles: they are extremely correlated! Encapsulating a specific design choice by introducing a new module, for instance, generally reduces coupling, introduces a better separation of concerns, and naturally leads to a good cohesion and information hiding at that place. Unfortunately, the reverse is also true: forget to encapsulate some design choice and you'll also augment coupling and reduce cohesion. If that design choice is questioned later, the software will likely be extremely difficult to refactor... and reacting to changes will be challenging.

A simple word, _independence_, sometimes requires a long discourse ;-)

## Credits

Coding patterns are mine. I'm really grateful to Axel van Lamsweerde (my thesis promotor), for introducing me to the underlying principles in his Requirements Engineering course[1]. While not being sure about their origin, I think that those principles have been initially proposed by David Parnas[2] and Barry Boehm[3]. Anyway, these authors propose excellent lectures about them.

## References

1. Axel van Lamsweerde, _Requirements Engineering: from system goals to UML models to software specifications_, Wiley, 2009.
2. David Parnas, _"Software Aging" in Software Fundamentals_, Addison-Wesley, 2001, pg. 557-558, 563.
3. Barry Boehm. _Software Cost Estimation with COCOMO II_, Prentice Hall, 2000, pg. 23, 28.