--- 
title: Whole Revision-Zero.org in a single .html file
short: This blog as a book
date: 2010-02-07 12:39:00 +01:00
category: Revision-Zero.org
keywords: 
- html image embedding
- templating engine
---
Two hours ago, I said that this blog had a new implementation based on WLang. Migrating to wlang also leads to new features... Here is a typical use of wlang: write your website once, compile it to different formats (self-contained html book, static website, small web server on your computer, deployment inside apache...)

### So, where is the book?

Just <a href="@{http://revision-zero.org/downloads/revision-zero.html}" target="_blank">here</a>... Save the .html file on your disk and open it with a good browser (all but one... let's say). This file is strictly self contained: images are embedded, all writings are included, etc. *You can read it offline*... that's all!

How does it work?

A bit of CSS:

#<{css}{ul#writings li.current a { text-decoration: underline; font-weight: bold }}

A bit of javascript (many thanks to @{http://www.query.com/}{jquery} for their job):

#<{book/allinone.js}

And, for images we embed them as base64 (more information and tools about this technique @{http://www.greywyvern.com/code/php/binary2base64)}{on this site}:

#<{html}{<img src="data:image/png;base64,..."></img>}

h3(#how). Where is wlang in here ??

The three basic (and probably well-known, except the last one maybe) techniques above have nothing to do with wlang. WLang helps me @{independence}{reaching _independence_} around them, probably the most important thing that I know about computer science.

What does independence mean in this book context? It means that the blog sources (layouts, writings, css, javascript) are completely independent of their usage (static blog generated as .html distinct pages, book self-contained .html file, dynamic website that composes the pages on demand, and so on.). I can't explain the whole architecture of the blog sources (see @{http://github.com/blambeau/blambeau.github.com/tree/revision-zero}{github} if you want to read the sources), but here is an example of how it works:

Here is a typical blog page, say <code>book/hello_reader.r0</code>, written in @{http://en.wikipedia.org/wiki/Textile_(markup_language)}{textile markup language}, but containing wlang tags (<code>\@{abstract_link\}{label of the link}</code>, for instance).

#<{book/hello_reader.r0}

On the version of the blog that you are currently reading, this code is transformed by wlang as:

#<{html}{^{redcloth/xhtml}{<<+{book/hello_reader.r0}}}

Have a look on the different versions now: here, on @{http://www.revision-zero.org/book#how}{revision-zero.org} and @{http://www.revision-zero.org/downloads/revision-zero.html..}{the book}. WLang adapts itself to the environment. This is made possible because the blog source code is sufficiently abstracts (what needs to be done for links is not explicitely described). Abstraction is the true nature of quality computer science.

h3(#further). Going further...

WLang can do a lot more... For example, the two code exerpts above are generated using the following wlang source codes:

#<{book/source1.r0}

#<{book/source2.r0}

No so difficult in fact, the code above use the following wlang tags (see @{http://blambeau.github.com/wlang/specification.html}{wlang documentation} for details):

%{wlang/dummy}{
<table>
  <tr>
    <td><code>@{url}{label}</code></td>
    <td>renders a link, according to the environment (advanced topic, in fact)</td>
  </tr>
  <tr>
    <td><code><<{url}</code></td>
    <td>includes the text content of the file denoted by _url_</td>
  </tr>
  <tr>
    <td><code><<+{url}</code></td>
    <td>instantiates the content of the file denoted by _url_ as a wlang template</td>
  </tr>
  <tr>
    <td><code>^{encoder}{source}</code></td>
    <td>encodes _source_ using a third party _encoder_</td>
  </tr>
</table>  
}
