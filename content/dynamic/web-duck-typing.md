--- 
title: Toward a static blog that looks dynamic
short: Web Duck Typing
date: 2009-01-11 17:35:00 +01:00
category: Blog
keywords: 
- duck typing
---
This revision, of course, talks about the development of revision-zero.org itself: I can't imagine maintaining my computer science blog by writing HTML files by hand! Everyone here knows that it would quickly lead to a nightmare: changing the template for example would require changing all articles that I've already written, maintaining page links would be difficult as well (my articles are numbered html files: <tt>0.html, 1.html, ...</tt>, one for each revision).

However, I don't want to use a web framework! Not because there are no good ones (there's a lot, in fact), but it sounds to me like "killing a fly with a cannon" (typical Belgian expression, don't know if it exists in English). So, I've decided to implement something myself: I keep my static files as the main architectural component and will try to reach an objective: this blog will walk like a dynamic site, it will quack like a dynamic site, I will call it a dynamic site, but it will mostly remain a static web site!
    
In particular this article is not written in HTML (that's already a good achievement) and it only took four hours to get that... Below is an explanation of my solution Before that, let me introduce the topic. I'm a newcomer to the Ruby programming language: I'm using it for only three weeks. On the @{http://www.ruby-lang.org/en/community/mailing-lists}{ruby-talk mailing list} last, week, someone asked the question "How Ruby?" (that is to say, "Can I master the language?"). Of course, I did not post a response to the question (I'm not a Ruby expert, not yet!) but I've got my own tricks to learn a new language. And my current objective (Web Duck Typing) provides a good example: I choose a project which is probably too hard for me, and I read other's code. So, let's turn to the solution now:

## From plain text to HTML

A great command-line tool coming with the Ruby distribution is @{http://rdoc.sourceforge.net/}{rdoc}, which allows you to generate a javadoc-like documentation for your implementation projects. In particular, it can generate an html version of the README, INSTALL, CHANGELOG, etc. files. Moreover, those files are written in plain text: this is similar to the feature I'm looking for this blog. My plan is simple: I write my articles in the _rdoc_ format (see below) and will use _rdoc_ itself to generate my static files.

Unfortunately, thinks get more complicated when you invoke the _rdoc_ command on a single file: it generates a whole documentation folder and expects your file to be part of a Ruby implementation project, which is not my case. Of course, I could try to learn how to write a specific template (seems an hard task), give _rdoc_ access to my CSS file, etc. However, there's an easier way: the @{http://rdoc.sourceforge.net/doc/classes/SM/SimpleMarkup.html}{SimpleMarkup} class, that I've found quickly thanks to the sentence <em>If you want to use the library to format text blocks into HTML, have a look at SM::SimpleMarkup.</em> appearing @{http://rdoc.sourceforge.net/doc/index.html}{here}. Moreover, the developer of _rdoc_ seems to be Dave Thomas, a really famous @{http://www.pragprog.com/}{pragmatic programmer} ! Good news: it looks like code that I can reuse!

The <tt>SimpleMarkup</tt> class parses your plain text file, recognizes the simple markup language of _rdoc_, and its companion class <tt>ToHtml</tt> generates HTML from the parsing result. Moreover, you can install you own recognition patterns in order to extend the markup language. Exactly what I need: a simple HTML text file (without <tt><html><body></body></html></tt> tags) generated from a simple plain text file!

## Embedding generated HTML in a template

The HTML generated by <tt>ToHtml</tt> is not aware of the template I use. So I still need to embed it in order to get well formed HTML documents. This time (or once again), I will implement it myself! The reason is that, a long time ago, I've invented my own  templating language which is called _wlang_ (for some obsure reasons). I will certainly @{wlang}{talk deeply about wlang} on this blog later; today, I will introduce only a small subset of its features:

%{
1. _wlang_ is not designed to generate HTML specifically. It is designed to generate text files in general. However, I must confess that I use it mainly for HTML/XML generation.
1. _wlang_ takes a text file as input and generates mostly the same text file as output. The only thing it does is replacing special markups like <tt>${varname}</tt>, <tt>+{varname}</tt> and <tt>@{varname}</tt> by something else. Replacements performed by these operators are called <em>injection</em>, <em>inclusion</em> and <em>linking</em>, respectively. _varname_ is an abstract reference to some program variable (abstract here means that it depends on the implementation).
1. The difference between these three operators is a follows (assuming that we generate HTML specifically): 

<table>
  <tr>
    <td><code>${varname}</code></td>
    <td>injects the value of the variable <tt>varname</tt> as plain text embedded in the HTML (that is, the value MUST be entities-encoded: if the variable contains <code><script>...</script></code> for example, it will never generate an HTML tag) ! That is, your templating engine takes care of disallowing basic XSS attacks (unless robust validation technique is used, this operator should always be used for inclusion of user data in the page, i.e. data coming from an HTML form for example).</td>
  </tr>
  <tr>
    <td><code>+{varname}</code></td>
    <td>includes the value without encoding, which is powerful for a templating engine, but should be used with care!</td>
  </tr>
  <tr>
    <td><code>@{varname}</code></td>
    <td>renders the value as an address link. The exact behavior of this operator would bring me too far. However, note that, in the case at hand, it does not generate a complete <code><a>...</a></code> link, but only the content of the _href_ attribute.</td>
  </tr>
</table>

Enough for today about _wlang_. The solution to my problem is so simple now: this page is generated from a _wlang_ template, containing <code>${title}</code> (in the header), <code>@{next}</code> and <code>@{previous}</code> (for the two links at the top of the page, really simply done thanks to my .htaccess file, see the first revision) and <code>+{contents}</code> for the article text here. That's it! Details can be found in the implementation below.
}

## The implementation

The Ruby implementation of the tool I've built to help me in my writing task simply consists of two classes: <tt>RevZeroMarkupRecognizer</tt> and <tt>RevZeroTemplateInstanciator</tt> for the two sub tasks presented before.
  
As I did not have a _wlang_ implementation in Ruby so far, I've implemented only the subset presented before. Ruby is a fantastic programming language: the core method of the corresponding class looks like this:

#<{web_duck_typing/web_duck_typing.rb}

The entire code of this article being really specific to what I'm doing for this blog, I won't give it for download. However, feel free to send me an email if you want to have a copy (under a GPL licence). I'm also pretty sure that a more complete Ruby implementation of _wlang_ will appear here soon! 

See you at @{2}{revision 2} !