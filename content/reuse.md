--- 
title: Software Reuse, in theory
short: Software Reuse, in theory
date: 2011-01-18 16:53:00 +01:00
category: Architecture
keywords: 
- reuse
- software reuse
- architecture
- process communication
---
With colleagues we have a somewhat recurrent discussion about _software reuse_. Discussion has raised once again recently, so I decided to summarize my personal point of view on this blog. After a short review of a good (yet already old) paper from the scientific literature, I would like to discuss the specific difficulties I've almost always encountered in my own work and my two-cents proposal to have more effective reuse in practice. I start with the paper review in this post; in the next one I'll try to provide a more practical lecture of software reuse.

## A short review of a survey

The concept of _software reuse_ is not new and many writings already exist about it. Probably the better I've read so far is a review due to Charles W. Krueger published in 1992 and simply entitled _Software Reuse_[1]. The abstract starts with the following paragraph:

> Software reuse is the process of creating software systems from existing software rather than building software systems from scratch. This simple yet powerful vision was introduced in 1968 (ed. in [2]). Software reuse has, however, failed to become a standard software engineering practice. In an attempt to understand why, researchers have renewed their interest in software reuse and in the obstacles to implementing it. 

The paper is actually a survey of the research efforts at that time about _reuse techniques_. The techniques discussed are (I will briefly discuss each of them a bit later): 

> _High-level languages_, _source code components_, _software architectures_, _design and code scavenging_, _application generators_, _transformational systems_, _very high-level languages_ and _software schemas_.

Each technique is more fully described in the body of the paper (a section of 2 to 3 pages each). There, they are  classified along four main dimensions:

* *Abstraction*. What are the ``software abstractions'' introduced by the reuse technique? In other words what is the type of software artifacts that are reused and what abstractions describe them?
* *Selection*. How are the reusable artifacts intended to be selected for reuse? How to locate and compare them, for example?
* *Specialization*. Artifacts are generalizations. Reusing an artifact implies having a way to specialize it back (through parameters, constraints, ...). How is this achieved for each technique?
* *Integration*: How are reusable artifacts integrated inside the complete software system under construction? 

The paper also aims at _evaluating_ the effectiveness of the reuse techniques, or at least it gives clues to do so. For this it calls for gauging the effectiveness of a reuse technique in terms of _cognitive distance_, that is, in terms of the _intellectual effort required (by software developers) to use it_. Interestingly, the author points out in his conclusion that the cognitive distance can be reduced in two ways:

* By reducing the intellectual effort required to go *from the conceptualization of a system to a specification* in the abstractions proposed by the reuse technique and, 
* By reducing the effort required to *produce an executable system from that specification*.

The paper also provides an approximate ranking of the height reuse techniques, rated on how well they minimize cognitive distance by each of the two methods mentioned above. _Application generators_ win the first ranking while _high level languages_ win the second one (refer to the paper for details).

## A first personal opinion

I'd like to close the paper review with something maybe more subjective. First, we can argue retrospectively about the effectiveness of the reuse techniques. The same certainly applies about the paper rankings. My personal feeling however is that the rankings are quite convincing even if not all reuse techniques suffer the same success. Second, I would like to point out how relevant the _research method_ seems to me (don't forget that the paper has been published in 1992): 

* Most of the reusable artifacts and reuse techniques I know and use everyday are covered by this survey.
* In my opinion, the four dimensions chosen for classifying them still give remarkable clues today for comparing and improving the tools we have.
* When evaluating the effort required to apply a reuse technique, the notion of _cognitive distance_ and the relevance of distinguishing between ease of specification (in terms of reusable abstractions) and ease of realization (i.e. obtaining an executable) is definitely worth considering ... and should be considered much more often, IMHO (at the risk of making a forward reference: your technique/language/library/whatever is only effective if it helps gaining both ways, or at least if gaining one way is not at the expense of the other).

Of course, I'll specifically refer to these points later in this post. Before actually discussing the specific difficulties I encounter in practice, I would like to review the different reuse techniques discussed in the paper in the light of the languages and tools I personally use at the time of writing.

## Quick overview of Reuse Techniques

Nowadays, no one would seriously argue that _software reuse has failed to become a standard software engineering practice_. Let have a quick look at each of the technique mentioned in the paper, in the light of the tools we have today. Note that I've tried to be consistent with the paper, in terms of the software abstractions behind each reuse technique. Some of the terms used in the paper may have a slightly different meaning today. Also note that the different techniques may overlap, as already pointed implicitly by Krueger himself. I must add that the presentation order I've chosen is related to my own understanding of the concepts ;-) Therefore, all subtitles and some other links below can be used easily to launch a google search!

### @?{High Level Languages}

Java, Clojure, Ruby, Haskell, and so on. High level languages are numerous and various. Each one comes with its set of tools to raise the abstraction level (sometimes in certain respects only, like providing good abstractions for concurrency, or low-level tasks).

### @?{Source code components}

High level languages also come with effective abstractions to build and share "abstract data types" and other "reusable libraries". Source code components are generally intended to be used as black-boxes: a public interface of usage is announced, formally or not (ruby has not equivalent of java interfaces, for example), while the realization of this interface is kept hidden (or at least intended to be). Think to C libraries, java's .jars, python's modules, ruby's gems, and so on. In many languages, "find a component, download it, and go" has become a reality!

### @?{Software architectures}

Software architectures are large-grain software frameworks. In contrast with source code components which are often black-boxes, software architecture are designed as grey-boxes: they are intended to be extended and provide specific extension points for this. We have a lot of reusable frameworks nowadays. Probably the most common are _web frameworks_ (@{http://rubyonrails.org/}{Ruby on Rails}, @{http://www.djangoproject.com/}{django}, @{http://www.asp.net/}{ASP.net}, ...), _integrated development environment_ (IDE, @{http://www.eclipse.org/}{Eclipse} is worth mentioning due to its architecture), _service oriented architectures_ (SOA), and so on.

### @?{Design and code scavenging}

Design and code scavenging is simply a form of "find, copy-paste, adapt". The well-known design patterns[3] provide an organized form of _design scavenging_, by providing _catalogues_ for applying such kind of reuse.  Even if invented in the context of the object-oriented programming, design patterns had a great impact far beyond that programming paradigm.

_Code scavenging_ is less organized as few such catalogues exists. Every day however, the web gives use better ways to apply such a reuse technique: @{http://www.google.com/codesearch}{google code search}, @{https://gist.github.com/}{github's gist}, @{http://www.pastie.org/}{pastie}, and so on. I also remember having read an book about Eclipse[4] whose authors encouraged applying the @?{monkey see, monkey do} rule, that is, copy pasting code from other Eclipse plugins whose source code is available.

### @?{Application generators}

The paper compares _application generators_ with _software compilers_. According to it, generators differ from compilers in that _the input specifications are typically very high level, special-purpose abstractions from a very narrow application domain_. I would add that compilers traditionnaly transform source code from a high-level language to something which is intended to be executable by a (virtual) machine, while application generators transform (very) high level descriptions into code that generally need to be compiled in turn.

In that sense, parser generators (@{http://dinosaur.compilertools.net/}{lex & yacc}, @{http://www.antlr.org/}{antlr}, @{http://cs.nyu.edu/rgrimm/xtc/rats.html}{rats!}, @{http://treetop.rubyforge.org/}{treetop}, @{http://fdik.org/pyPEG/}{pyPEG}, and so on.) are probably the best-known examples of application generators. Other examples include wizards that one can find in Integrated Development Environments (to design and generate code of user interfaces, for example), tools that generate classes from UML class diagrams, generators of database schemas, report generators, etc. In note in passing that the @{noe}{Noe library I was talking about recently} is of course a kind of application generator.

### @?{Transformational systems}

Transformational systems are the holy grail of computer science, nothing less! In that paradigm, software developers actually describe the behavior of the software using a high-level specification language (related to VHLL described before). In a second phase, the specifications are transformed in order to produce an executable system. The transformations are meant to enhance efficiency without changing the semantics.

Transformational systems emphasizes the _what_ instead of the _how_. They actually bet on the concision of declarative statements over procedural ones to achieve effective reuse. While general purpose transformation systems remain mostly research topics, notable results have been achieved in some specific domains: relational systems come with effective query optimizers, some rapid prototyping approaches uses transformations from high-level descriptions down to code, etc.

### @?{Very High Level Languages} (VHLL)

_Very High Level Languages_, also known as _executable specification languages_, are languages with very high level of abstraction.  They are somewhat difficult to capture precisely and may lead to software reuse that is very specific to specialized domains. However, I would say that the recent advent of Domain Specific Languages (DSLs) and good support for them in dynamic languages (ruby, python, clojure, ...) can be seen as promoting and helping building VHLLs.

### @?{Software schemas}

I must confess not being familiar with software schemas. The paper states that _software schemas are a formal extension to reusable software components_ . From what I understand, it seems that we are talking about some kind of formal pseudo code, intended to be instantiated in a particular language. Unfortunately, @?{software schema}{a google search does not return relevant results}, at the time of writing. I would like to know if they had an impact on current software engineering practices. So if someone knows something about _software schemas_, just let me know (see the comment form at bottom of this page), and I'll be happy to update this section!

## Conclusion

In this post I've tried to lay some sound foundations for a more practical discussion about software reuse in practice that will take place in a later post. For this, I've mainly reviewed a paper from 1992, namely _Software Reuse_ by Charles W. Krueger. Beyond the specific software reuse techniques discussed, I'm convinced that the classification and evaluation proposed by the author makes sense. Software reuse means having good abstractions as well as tools to _select_, _specialized_ and _integrate_ them inside a larger software. Effective reuse is best achieved by techniques that minimize the intellectual effort required by software developers to express an abstract specification as well as converting it to something executable.

See you at the @{reuse_in_practice}{practical session about reuse}!

## References

1. Charles W. Krueger, @?{Charles W. Krueger Software Reuse}{_Software Reuse_}, ACM Computing Surveys, Volume 24 Issue 2, June 1992
2. Peter Naur and Brian Randell, @{http://homepages.cs.ncl.ac.uk/brian.randell/NATO/nato1968.PDF}{_Software engineering: Report of a conference sponsored by the NATO Science Committee_}, Garmisch, Germany: Scientific Affairs Division, NATO, October 1968
3. Erich Gamma, Richard Helm, Ralph Johnson, and John Vlissides, @?{Design Patterns: Elements of Reusable Object-Oriented Software}, Addison-Wesley, 1995. ISBN 0-201-63361-2
4. Erich Gamma and Kent Beck, @?{Contributing to Eclipse: Principles, Patterns, and Plug-Ins}, Addison-Wesley, October 2003. ISBN 0-321-20575-8