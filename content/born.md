--- 
title: Welcome to Revision-Zero.org!
short: Revision-Zero is born!
date: 2009-01-10 18:16:00 +01:00
category: Revision-Zero.org
keywords: []

---
Welcome to revision-zero.org ! You are reading the really first revision of this web site. If you read this page you are probably asking yourself what this site is about ? It is about computer science, and only about that. So if you're not a computer scientist or somewhat interrested by computers, you probably won't find any useful information here. Otherwise, read on!

I've created this web site to share ideas. I'm a computer scientist, currently attached (as researcher) to the computing science department of the University of Louvain (Université catholique de Louvain-la-Neuve, Belgium). As a researcher, my job is to have ideas (nice job isn't it?) ... sometimes good ones, sometimes not. I've not enough time to implement everything so I've decided to share it ! However, unless you're reading this page in the future, you'll have to wait for subsequent revisions ... But I can already precise the topic somewhat: this web site will most certainly provide code tricks in Ruby and Java, will certainly talk about databases, requirements engineering and goal modeling in particular, automata, regular languages and induction, I'm sure web frameworks will have a place, ... But before that, let's talk a bit about the web site itself.

### Revision-Zero's revisions

You're currently reading revision 0 of this web site. Each time a new article is posted, the revision number is increased. The web site itself will be under constant development. It's a choice: I didn't wanted to select and learn an 'all-in-the-box' blog implem or something like that. So I will create it myself, pragmatically, implementing features when need arrive ... Some posts here will certainly talk about  that development. Revision number 0 is an hand-written simple html page. You can read future revisions of this one with a simple URL pattern:

<center>@{http://www.revision-zero.org/32</center}{http://www.revision-zero.org/32}>

for example, will bring you to the revision numbered 32, which (if already available) is about some computer science topic, maybe about this site development, maybe not.

### Revision 0's implementation

This first revision of the web site is pragmatic and simple: it's a simple HTML/CSS file, and something like the following lines in the .htaccess file, providing the first navigation mechanism:

#<{text}{<<{htaccess.txt}}

Simple isn't it?? Everything will certainly change in the implementation in a really short-term future but it makes the job for now and has been implemented in a couple of minutes (I'm lying: I don't masterize mod_rewrite at all and it took a lot of time to me to write these simple four lines. It should be read as: <em>[...] it makes the job for now and <b>can</b> be implemented in a couple of minutes</em>).
            
### Revision-Zero's material
            
And now, for something really important. Unless stated explicitely, all ideas written here are the intellectual property of Bernard Lambeau. All text material is under a @{http://creativecommons.org/licenses/by/2.0/be/}{Creative Commons Licence 2.0} contract. Unless stated explicitely, short code excerpts appearing here may be used freely, but are given without ABSOLUTELY NO WARRANTY. Source code (clearly indicated as being) extracted from a given implementation project of the present author remains under the same licence as the project it is extracted from (often @{http://www.gnu.org/licenses/gpl.html}{GPL}, @{http://www.gnu.org/licenses/lgpl.html}{LGPL} or @{http://www.opensource.org/licenses/mit-license.php)}{MIT}.

I'm really grateful to David Herreman (the one I don't know) for the CSS template that I've downloaded from www.free-css-templates.com (pragmatic implementation choice!). This template is under Creative Commons Licence as well.

Last but not least, thanks (as well as some rights) go to my employer (the University of Louvain). My brother also deserve special thanks for his help and support!

See you at @{1}{revision 1}, enjoy Revision-Zero!