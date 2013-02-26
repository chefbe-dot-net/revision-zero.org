--- 
title: Rack::Robustness, the rescue clause of your Rack stack
short: Rack::Robustness
date: 2013-02-26 12:33:00 +01:00
category: Ruby
keywords:
- Exception handling
- Software engineering
- Architecture
- Ruby
---
I'm glad to announce the release of @{https://github.com/blambeau/rack-robustness}{Rack::Robustness 1.0}, a rescue clause for web applications in Ruby. I've been thinking about robustness and exception handling for some time now (since a talk I gave a year ago, that you can watch @{http://www.youtube.com/watch?v=PLw1CRRTn8c&list=PLYqVo6TvsD0wsZE_yj_vg-7L92jUv9a9p&index=2}{here}) and I hope that I'll find the time to write a a bit more about that work here in the next few weeks.

In the mean time, for Rubyists only:

#<{ruby}{
gem install rack-robustness
}

Then (see @{https://github.com/blambeau/rack-robustness#rackrobustness-the-rescue-clause-of-your-rack-stack}{README} for additional, and better, examples):

#<{ruby}{
use Rack::Robustness do |g|
  g.status 500
  g.content_type 'text/plain'
  g.body 'A fatal error occured.'
end  
}

## Why?

I'm more and more convinced that how to handle exceptions properly is as subtle as it is currently unknown by most. In web, it leads to a all or nothing behavior:

* Crash
* Don't crash, just say `Error 500: a fatal error occured`

Their are a ton of more intelligent ways to handle exceptions:

* you can *eliminate* them, sometimes
* you can *reduce* their likelihood
* you can *tolerate* them
* you can *restore from* or *mitigate* their consequences
* etc.

For this, you first need a mechanism to catch them. Obviously, Ruby's `rescue` clause exists. Unless all you controllers, all your middlewares, and/or all your Sinatra routes catch all errors, some exceptions will eventually propagate through the Rack call stack. That's a fact.

Along the Rack call stack, Ruby's `rescue` clause is no longer directly available to the application developer. Generic exceptions handlers provided by frameworks such as Rails or Sinatra are not enough because they don't allow to respond to exceptions in an application-specific way. `Error 500: a fatal error occured` is **not** and application-specific way, even if well presented in HTML/CSS.

Hence, you need a dedicated and configurable middleware. `Rack::Robustness` is such a middleware and it aims at being as powerfull as needed. Indeed, it provides a dedicated place to have a systematic, consistent and simple response to obstacles/exceptions. Your routes, middlewares and controllers no longer need to be fully robust. They can even throw exceptions on intent and that's a relief. Exception handling **is** needed and the first step to mastery is to avoid being affraid to throw exceptions.

Something goes wrong and you don't know how to react? Throw an exception or let it propagate. Then put something somewhere to respond to exceptions in a consistent way. Something like Rack::Robustness.
