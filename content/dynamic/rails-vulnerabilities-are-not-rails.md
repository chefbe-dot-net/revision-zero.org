--- 
title: Rails vulnerabilities are not Rails'
short: Non-Rails vulnerabilities
date: 2013-01-11 18:55:00 +01:00
category: Ruby
keywords: 
- ruby on rails
- ruby
- sinatra
- YAML
- data serialization
---

TL;DR; Rails has demonstrated that YAML is an unsafe serialization format, at least in some environments such a Ruby. That's odd because it was one of the richest available serialization formats (sic), allowing to pass type-rich (say) and structured data between distributed software modules. Much richer than URL-encoded and XML at least. In 2013, JSON will remain the only decent alternative, ... that does not support times and dates, though.

The Ruby on Rails community just wakes up from a security nightmare. Two security issues have been discovered recently, namely @{https://groups.google.com/group/rubyonrails-security/browse_thread/thread/b75585bae4326af2}{CVE-2013-0155} and @{https://groups.google.com/group/rubyonrails-security/browse_thread/thread/eb56e482f9d21934}{CVE-2013-0156}. They are considered critical because they "allow attackers to bypass authentication systems, inject arbitrary SQL, inject and execute arbitrary code, or perform a DoS attack on a Rails application".

Many web pages already describe the security holes, @{http://ronin-ruby.github.com/blog/2013/01/09/rails-pocs.html}{how to exploit them}, how Rails has been fixed, etc. Some outsiders laugh at Rails on twitter or simply congratulate themselves from having chosen another framework or programming language.

However, everybody seems silent about the *real* security issue hidden behind @{https://groups.google.com/group/rubyonrails-security/browse_thread/thread/eb56e482f9d21934}{CVE-2013-0156} in particular. In my opinion, it has nothing to do with Rails and probably not with Ruby either. For instance, I would not be surprised to hear that some Sinatra application are affected by a similar security issue. Why?

## The real security issue

In short, the root cause of this security hole is as simple as this:

> Parsing an untrusted/tainted YAML source (in Ruby, with Psych) is unsafe.

That's all, ... but the parenthesis maybe. I don't know whether the same is true using Syck (an older Ruby YAML parser) instead of Psych. I don't know whether other programming languages are affected by something similar. It seems to me that it might be the case, but I'm not sure. I will therefore keep a (in Ruby, with Psych) assumption in this post to avoid over-generalizing and let you investigate further for other situations.

## Rails is *not* a precondition

First, observe that Rails is *not* a precondition of the security issue as described. *Parsing an untrusted/tainted YAML source in Ruby with Psych is unsafe.* No Rails. Really?

#<{ruby}{
  source = "--- !ruby/hash:AVulnerableClass {hello: 'world'}"
  YAML.parse(source)
}

The YAML source above is perfectly valid. When parsed by Psych, it will execute something similar to the following code:

#<{ruby}{
  data = AVulnerableClass.new  # not exactly, but almost
  data['hello'] = 'world'
}

In other words, a malicious user of any Ruby application that parses YAML (with Psych) from her input may easily:

* instantiate any ruby class available to the application
* try to exploit a `[]=(name, value)` instance method on such class, especially one that does something dangerous with the `value` parameter such as evaluating code or executing a system command.

## So what?

Rails fixes the issue in a quick and dirty way: now it prevents controller parameters from being passed as YAML. Such fix certainly makes sense, especially when you know that the real issue occurs when those parameter values are specified as a YAML *datatype* embbedded in an XML request (Rails controllers do not allow YAML input directly). YAML is *not* a datatype, it is a serialization format. The fix at least removes a strong confusion between data types and physical representation of their values, in addition to fixing the security problem of course.

The whole story does not end here. Why on earth do Rails controllers accept URL-encoded, JSON and XML serialization formats for parameters, but no YAML? Probably because no developer has ever asked for such support? Maybe because the security issue was already known? Because most clients of rails controllers are written in HTML/javascript and using  YAML is such context is not idiomatic.

Would it make sense for Rails controllers to accept YAML-encoded parameters? Of course it does. URL-encoded, XML, and JSON are data *serialization* formats, YAML also. Abstracting a bit, the invocation of a Rails controller is nothing but a remote procedure invocation between the front-end and the backend of a web application, between a client and a server (in a client-server architecture), more generally between two distributed modules in your software. The choice of a serialization format is an implementation detail. You take the one that naturally fits. Imagine a client for which YAML naturally fits and you'll ask rails controllers to take YAML as input. 

Now, forget about Rails and think about any distributed software for which one module naturally takes structured data as input. What if YAML is natural choice for its clients, because the end-user is involved for instance. Will you choose it?

No, because YAML parsing is unsafe.

## Conclusion

The conclusion of not using YAML is a pitty, in many respects. As a though provoking conclusion, let me simply state that in 2013, passing structured data between distributed software modules remains a complete nightmare. Available choices are:

* URL-encoded parameters have implicit datatypes by nature (all strings) and do not provide ways to capture structured data (key-value pairs only),
* XML is verbous, has implicit datatypes and accidental structures (nodes and attributes, but no arrays, no lists, no maps),
* JSON has a few datatypes (string, integer, Boolean, but no time, no date, no url, no color, etc.) and a few good structures (arrays and dictionnaries),
* YAML has even richer datatypes (string, integer, Boolean, time, date) and good structures (arrays and dictionnaries), but is not safe (in Ruby)

Why not simply having a serialization format with rich datatypes (including safe user-defined ones) and rich structures?