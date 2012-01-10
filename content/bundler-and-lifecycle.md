--- 
title: Bundler in the Software lifecycle (cheatsheet)
short: Bundler cheatsheet
date: 2011-02-04 17:00:00 +01:00
category: Ruby
keywords: 
- ruby
- bundler
- bundler cheatsheet
- deployment
- releasing
- deploying
- lifecycle
---
I've read @{http://gembundler.com/rationale.html}{Bundler's documentation} recently because I wanted to better understand how it is supposed to be used. My learning has been a bit difficult for a simple reason: there is a lot of text on Bundler's website, but no real concrete scenario explained with a good old image. So I've decided to share the one I've built during my learning:

<notextile>
<p style="text-align:center;">
<a href="images/bundler_and_lifecycle/bundler_and_lifecycle.pdf"
   target="_blank"><img src="@{images/bundler_and_lifecycle/bundler_and_lifecycle.gif}"/></a>
</p>
</notextile>

* This cheatsheet is *not dedicated* to Rails, Sinatra, or whatever the technology you use. It is not even dedicated to web applications... I've tried to keep it somewhat abstract: developing, releasing, deploying is sufficiently general IMHO. 
* However, it *is dedicated* to _applications_ (in contrast to _libraries_) because bundler is designed to handle such cases (and @{http://goo.gl/RpV4a)}{is not intended to be used inside gems}. The cheatsheet can still be used but must probably be adapted if you use bundler to _develop_ a gem.
* This is *one typical, simplified use case*. The lifecycle is certainly arguable. My aim is only to illustrate where bundler subcommands are typically used.

I won't explain this cheatsheet any further, not because I'm lazy, but because I would like it to be completely self-contained and self-explanatory. Don't hesitate to ask questions or send comments with the form below and I'll update the cheatsheet if needed!

