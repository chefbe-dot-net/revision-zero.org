--- 
title: Open-sources libraries available
short: Release Time!
date: 2009-03-13 10:17:00 +01:00
category: Free Software
keywords: 
- open source
- ruby libraries
---
It's been a long time since my last post here! I've reached a major milestone yesterday so it's time for me to write about it. I've spent most of the last weeks developing, re-developing, and developing again. Not for the blog, not for my research (at least not directly) but in order to create tools (and I hope _quality_ tools), as tools are definitely required to build big things on solid foundations. This post is therefore also a public announcement: @{http://code.chefbe.net}{these tools are available as open source libraries} (MIT license).

It has always been hard for me to decide when it is the time to release: new code may present bugs, insufficient test coverage or documentation, experimental ideas or features (this code is written by researchers and our job is to experiment with things: even if the code is considered stable, the ideas it implements really can be experimental). This time, I've decided not to be too shy and to release anyway. The code is now there and it can be used, that's an important achievement.

I've chosen to release three Ruby libraries that are not too experimental and are stable enough to be shared. Here are they:

## @{http://github.com/blambeau/wlang}{WLang reference implementation}

If you have read previous posts, you have already heard a bit about _wlang_. Instead of first writing in detail about it, I've decided to spend time implementing a stable reference implementation. Two versions are @{http://code.chefbe.net}{available online}: a first stable version tagged 0.7.0 and the trunk version we (my brother and I) are still working on.

It's hard to explain exactly what _wlang_ is but here is the rule: if you have to generate text (html, code, plain text, documentation, templated mails, or whatever else) by injecting data inside templates, _wlang_ is for you! It has been carefully designed to be simple to use, powerful and extensible. The API documentation for the reference implementation (in Ruby) can be browsed @{http://code.chefbe.net/docs/wlang/stable-0.7.0/api/index.html}{here}. Probably more useful, the @{http://code.chefbe.net/docs/wlang/stable-0.7.0/api/SPECIFICATION.html}{reference card} explains you everything you need to know.

We are still working actively on _wlang_ and plan to release a first 1.0 milestone release in the next few weeks, with a lot of additional examples.

## @{http://github.com/blambeau/anagram}{Anagram}

This library is born from a long history of research and interests, spanning years, that resulted from one simple realisation: I've always been bored by classical parser generators. Writing your grammar is often a nightmare! I've been introduced to @{http://en.wikipedia.org/wiki/Parsing_expression_grammar}{Parsing Expression Grammars} (PEG) three years ago. In my opinion, PEG is a much simpler and intuitive methodology than other parsing techniques so I've started a Java project a long time ago based on @{http://cs.nyu.edu/rgrimm/xtc/rats.html}{Rats!}. This project was however way too experimental, not sufficiently tested nor documented and therefore it will never be released as a public library. 

Even if I use Ruby a lot today, I'm of course facing the same needs as before (my research hasn't changed because of a language shift). I was missing my PEG parsing tools in Ruby so I've started looking at people sharing this concern. @{http://treetop.rubyforge.org}{Treetop} is a PEG parser  generator for Ruby that I strongly recommend: first, it is PEG parsing; secondly, the language used to write grammars is clean and simple; thirdly, it is in Ruby, leading to powerful mechanisms around your parser.

As you know, I'm a never happy guy: your parser generates a purely syntactic tree, and everything (each space, parenthesis, bracket, carriage return, comment, etc.) becomes a tree node. Nothing important in Treetop's common thinking: you can embed ruby code in your grammar definition and ignore those nodes. Personally, I don't like embedding code in my grammar: it makes it usable for Ruby only (otherwise  it can be seen as a language-independent grammar definition). Moreover, you always need tools for the  semantic phase: convert strings to another data types (integers, booleans, ...), perform semantic checks (no two variables with the same name), parse other files (include, require, import exist in almost all languages), etc. At the end, you would like to use your tree to generate text or code in a specific language, digesting objects, etc. Last but not least this whole process, while involving somewhat big developments, is also a really small milestone from the point of view of the software to build (in other words, building semantical information from raw data is rarely a high level or strategic goal in your development).

Anagram is born from the lack of supporting tools for these hard (and a bit boring) tasks. It comes with a parser generator (same grammar format as Treetop), AST abstractions and rewriting tools, and can be used in conjunction with _wlang_ to generate code. The online version is still experimental but accurately depicts the picture: the code to generate a parser from your grammar file has less than 200 lines of code, thanks to rewriting tools and _wlang_.

## @{http://code.chefbe.net}{Chefbe Ruby Utility Classes}

Much more anecdotal, I've created a repository of utility classes that are useful in different projects. This first version contains only one class (a powerful composite Interval implementation) that a research team-mate would like to reuse (or inspire himself from). Many other classes will also be extracted from specific projects and stored in this repository instead. The rule for this project is simple: classes are self-contained (no intra/extra dependencies), well tested and documented. I will probably not create a gem for this project: pick up the classes you are interested in, copy them in your own codebase but please keep the licence header.

Enjoy those libraries!
