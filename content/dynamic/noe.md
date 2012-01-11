--- 
title: Skeleton-driven coding with Noe
short: Skeleton-driven coding
date: 2011-01-14 16:51:00 +01:00
category: Ruby
keywords: 
- skeleton-driven coding
- project skeleton
- gem library
- ruby template
- ruby
- rubygems
- ruby gem
- templating engine
---
## Hi all!

I've spent a few hours on a new project recently: the Noe ruby library (the source code is @{https://github.com/blambeau/noe)}{available on github}. Noe is born because I'm tired of always replaying the same scenario every time I start a new ruby library / scientific paper / java program / static or dynamic web site / and so on. You probably know what I mean: our projects follow conventions, and in particular well-defined folder structures and file templates. One would like to have tools to instantiate these structures and files in one click! Noe is such a tool:

#<{noe/starter.sh}

Before going any further, here is how to install it. You'll need a correct ruby installation to run it, see @{http://ruby-lang.org}{ruby-lang.org}. After that, noe is a simply ruby gem:

#<{noe/install.sh}

## Why not using existing tools for ruby?

Why reinventing the wheel, once again? Similar generators already exists: @{http://seattlerb.rubyforge.org/hoe/}{hoe} by Ryan Davis and Eric Hodel, @{https://github.com/fauna/echoe}{echoe} by Evan Weaver, @{https://github.com/TwP/bones}{bones} by Tim Pease and so on. They generate such a ruby structure from templates and do even better: they also (and somewhat magically) provide a lot of rake tasks to manage the lifecycle of your project (for those who might not know what a _rake task_ is, let simply add that @{http://rake.rubyforge.org/}{_rake_} is the ruby maker, a tool that helps running code-related tasks like building, testing, packaging, or releasing the program/library you are developing)!

Given my needs, I had two main reasons for not reusing/extending these tools:

* First, they do not support generating skeletons for something else than ruby projects. Nothing in their architecture looked designed for such a need so that extending them appeared difficult.
* Second, IMHO they violate some important principles: keep separation of concerns, achieve a strong level @{independence}{independence}, @{document_at_earliest_point_of_usage}{document at the earliest user point of usage}, provide magic only if it does not restrict features, and so on.

I won't argue here about such principles and their violation by the projects listed above. Drop me an email if you are interested in having details.

## Template -> Skeleton

Basic usage of Noe is really simple. First, you build (or reuse of course) a project template respecting a few conventions about _variables_ (like using `__varname__` in file and folder names). Then you provide a .noespec file (actually a good old .yaml file) that assigns values to such variables. Noe makes the rest: it instantiates the whole project template as a fresh new project skeleton!

![](images/noe/workflow.gif)

## Maintaining your Skeleton

The generation of a project skeleton is a good start, but Noe comes with additional power! For example, it allows you to modify your .noespec file later while regenerating only parts of the project skeleton (to avoid overriding your own work). This regeneration feature comes with different variants.

### Regenerating all files

When you start a new project you might want to write your .noespec file iteratively, generating the whole skeleton over and over again. Noe has a special mode for this:

#<{noe/genall.sh}

### Regenerating some files only 

It often occurs that some files are constants, up to a project configuration (that you may encapsulate in your .noespec file). Examples of such files in the ruby community are the Rakefile, the Gemfile, the .gemspec and so on. If the configuration changes, you can simply remove the old version and ask Noe to resurect the files:

#<{noe/gensome.sh}

### Trusting the template creator...

The creator of the template you use (maybe yourself) might have a personal opinion about what files should be kept under Noe's control (thanks to the configuration specified in the .noespec file) and which ones should not be overriden after the creation of the skeleton. Good templates come with full documentation about such assumptions. Noe provides a special mode for maintaining your skeleton safely, while respecting the creator conventions:

#<{noe/gensafe.sh}

### ... but keep control!

Even if you almost agree with the conventions of the template creator, you might want to maintain a file manually that would normally be kept under Noe's control. That file will be overriden everytime you invoke the previous command, and of course you want to prevent this from occuring. Fortunately, Noe comes with a powerful mechanism to override template conventions. This is done inside your .noespec file, under the template-info/manifest section. In the example below, we explicitely specify that the Gemfile may be overriden when using `--safe-override` while the Rakefile will be maintained manually.

![](images/noe/safe_override.png)

## Writing a template

At the time of writing, I'm still actively writing documentation for Noe, and a template maintainer guide in particular. I've imagined writing a Noe template for writing templates, but while perfectly possible, it quickly appeared that adding an additional level of meta-abstraction would lead to something less understandable than a good old explanation here.

After having installed Noe (see '`noe help install`') properly, you end up with a `~/.noerc` file with Noe's basic configuration and a `~/.noe` folder with default templates bundled with noe (have a look at the default ruby template). A template is basically a subfolder in `~/.noe` with the structure shown below.

![](images/noe/dotnoe.gif)

The specification file, namely `noespec.yaml` is used by '`noe prepare`' to generate the initial version of the project's .noespec file. It is generally much longer than shown, as the template creator may also provide variables with default values, specify a default @{https://github.com/blambeau/wlang}{wlang} dialect, provide a `template-info/manifest` to control the `--safe-override` option and override the default wlang dialect for specific files, and so on.

The `src` folder contains the meta-structure of the project skeleton. `__varname__` may be used in file and directory names. They will be renamed thanks to the values provided in the .noespec file when the skeleton is generated by '`noe go`'.

## Last but not least

I would not want closing this post without mentioning one of the greatest reason why I think that Noe could become a great and really friendly tool: files and instantiated by @{https://github.com/blambeau/wlang}{wlang}! WLang is designed to help generating code, i.e. to help you maintaining clean templates even for complex tasks through the support of dialects. So, let me close this post with another not so simple example:

![](images/noe/wlang_is_great.gif)

Enjoy @{https://github.com/blambeau/noe}{Noe}!