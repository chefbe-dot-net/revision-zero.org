--- 
title: The Sad/Amazing History of a Ruby[Gems] bug
short: Ruby/Rubygems Bug
date: 2011-03-01 14:07:00 +01:00
keywords: 
- ruby
- bundler
- rubygems
- bug
- RangeError
- bignum too big to convert into `long'
category: Ruby
---
In software development bugs may sometimes live for a very long time before being really fixed. Even when you think that you've fixed them, it may happen that they suddenly re-appear somewhere else. Bugs are like viruses in a sense: they can appear, fall asleep, move, mutate, and so on. I've found such one in the ruby community recently. His story is amazing and his consequences somewhat relevant for the ruby community, so I've decided to spend a day tracking and documenting it.

The signature of the bug is easy to recognize, you simply end up with a ruby error with the following message:

#<{sh}{/usr/local/lib/site_ruby/1.8/rubygems/requirement.rb:109:
  in `hash': bignum too big to convert into `long' (RangeError)}

If you have found this post recently (around March 2011), it's very likely that you've encountered this bug in one of the following situations (if not the case, it could be the very same bug but with some mutation; read on, fixes are probably the same):

* When running <code>bundler install [--deployment|--local]</code>
* When installing a few ruby gems at once via third party tools (capistrano, rails, ...)
* When phusion passenger attempts to start your rails/sinatra application

## Temporal bug review

The pristine bug is already old (about 2 years) and is due to a Fixnum -> Bignum overflow when computing a hash code, especially on arrays. It seems that it has been discovered in REXML and @{http://redmine.ruby-lang.org/issues/show/1883}{first reported on the ruby-lang bug tracker} the 05 of August 2009. Then it has been quickly fixed. More precisely it was already fixed when the issued has been created.

Anyway, similar bug reports rapidly appeared in rubygems bug tracker, namely the  @{http://rubyforge.org/tracker/?func=detail&atid=575&aid=26958&group_id=126}{20 of August 2009} and @{http://rubyforge.org/tracker/?func=detail&atid=575&aid=27154&group_id=126}{September 21, 2009}. Note that a first bug mutation occurs there. Indeed, <code>Gem::Specification.hash</code> is incriminated because it may return a Bignum in certain cases. The link with ruby's pristine bug remains clear and fixes are suggested to fix the bug independently of ruby, that is, in rubygems itself. Unfortunately, root cause analysis has not been well applied, and the bug has not been fixed exactly as suggested.

After that the bug seems to fall asleep and, according to Google search, @{http://bit.ly/fvwMVp}{remains silent during about one year} at least if you consider the main bug trackers in the ecosystem. However, during this very same year the @{http://gembundler.com/}{bundler project} becomes more and more mature. And the 29th August of 2010, the first stable 1.0.0 version is officially released together with @{http://weblog.rubyonrails.org/2010/8/29/rails-3-0-it-s-done}{Rails 3.0}.

The bug mutates and re-appears in only two days, with an new entry in @{https://github.com/carlhuda/bundler/issues/637}{bundler issues} on September 1, 2010. Users quickly perform root cause analysis, re-discover the @{http://rubyforge.org/tracker/index.php?func=detail&aid=27154&group_id=126&atid=575}{bug report on rubygems} then on ruby and close the issue on bundler itself.

Since that time, the @{http://rubyforge.org/tracker/index.php?func=detail&aid=27154&group_id=126&atid=575}{bug report on rubygems} gains a discussion from October to December 2010, a first request appears on @{http://help.rubygems.org/discussions/problems/335-marshal48z-still-not-updating-completely-as-of-21-september}{rubygems help} (September 21, 2010) quickly followed by @{http://help.rubygems.org/discussions/problems/418-rangeerror-when-running-gem-generate_index}{a second one} (November 20, 2010), a @{http://stackoverflow.com/questions/4295033/error-in-installing-bundle-in-rails-application}{rails-related question is asked on stackoverflow} (November 28, 2010), as well as a @{http://groups.google.com/group/ruby-bundler/browse_thread/thread/8307e5ffa4fc1cce}{mail on bundler's mailing list} (December 14, 2010) and @{http://stackoverflow.com/questions/4989618/error-while-installing-rspec-gem-bignum-too-big-to-convert-into-long}{another question when installing rspec 2.5.0 on stackoverflow} (February 14, 2010).

The @{http://rubyforge.org/tracker/index.php?func=detail&aid=27154&group_id=126&atid=575}{most recent bug report on rubygems} has been closed the 1th of February 2010 with a message "This is fixed." and no particular patch applied.

## Affected ruby[gems] versions

The issue has been fixed in ruby 1.8.7 in @{https://redmine.ruby-lang.org/projects/ruby-18/repository/revisions/25661}{Revision 25661} on November 5, 2009 by merging changeset r22308. Strangely, the @{http://svn.ruby-lang.org/repos/ruby/tags/v1_8_7_334/ChangeLog}{Changelog file of ruby's 1.8.7} does not contain any information about changesets applied between the 08 of April and the 26 of May. Therefore no trace of this fix has been officially kept. However, a quick bisection (thanks to @{http://rvm.beginrescueend.com/}{rvm} in passing) shows the following:

* <span style="color:red">ruby-1.8.7-p160 [ i386 ], KO, April 18, 2009</span>
* <span style="color:red">ruby-1.8.7-p174 [ i386 ], KO, (no official announcement)</span>
* <span style="color:green">ruby-1.8.7-p248 [ i386 ], OK, December 25, 2009</span>
* <span style="color:green">ree-1.8.7-2011.03 [ i386 ], OK, March 01, 2011</span>
* <span style="color:green">ruby-1.9.2-p136 [ i386 ], OK, December 25, 2010</span>

In spite of bug reports and patches introduced in rubygems bug tracker, no patch has been officially applied to rubygems itself so far, probably due to a lack of material to reproduce the bug and write a regression test. Therefore, unless your ruby version is greater or equal to ruby-1.8.7-p248, you are affected by the bug. In other words: 

* <span style="color:red">ruby 1.8.7-p174 + rubygems 1.5.3, KO</span>

## How to fix it?

At the time of writing, the only clean way to fix this bug is to upgrade your ruby version. As you probably know, if you are under Debian/Ubuntu and would like to rely on an official ruby package (at least for ruby itself), then ... hum ... you'll probably have to wait. 

Now that a dissection of this bug has been made, I personally hope that a fix will be available in rubygems itself for users relying on Debian packages on production servers. Alternatively you can patch your rubygems version as follows (see @{http://rubyforge.org/tracker/index.php?func=detail&aid=27154&group_id=126&atid=575}{rubygems bug tracker} for details):

#<{sh}{
blambeau@aello $ pwd
/usr/local/lib/site_ruby/1.8/rubygems

blambeau@aello $ diff -u requirement.rb.orig requirement.rb
--- requirement.rb.orig	2011-03-01 19:03:20.000000000 +0100
+++ requirement.rb	2011-03-01 19:03:41.000000000 +0100
@@ -106,7 +106,7 @@
   end
 
   def hash # :nodoc:
-     requirements.hash
+     requirements.inject(0) { |h, r| h ^ r.first.hash ^ r.last.hash}
   end
 
   def marshal_dump # :nodoc:
}

## Conclusion

I won't spend too much time concluding about all of this. Bugs happen are sometimes hard to understand and fix. However, I can't resist having a personal lecture of all of this in the light of somewhat recent discussions about @{http://www.lucas-nussbaum.net/blog/?p=617}{ruby packaging} and @{http://redmine.ruby-lang.org/issues/show/4239}{compatibility issues}. 

The fact that old bugs suddenly resurrect certainly means that users rely on ruby versions that important committers in the ecosystem already consider as 'oldies'... If OPs should certainly migrate (but need support to do so), committers should take care.

## Links

* August 05 2009, on @{http://redmine.ruby-lang.org/issues/show/1883}{ruby-lang bug tracker}, someone reports the bug in REXML
* August 08 2009, first appearance of the bug on @{http://rubyforge.org/tracker/?func=detail&atid=575&aid=26958&group_id=126}{rubygems bug tracker}
* September 21 2009, a similar issue appears on the @{http://rubyforge.org/tracker/?func=detail&atid=575&aid=27154&group_id=126}{rubygems bug tracker}
* September 1 2010, the bug reappears in @{https://github.com/carlhuda/bundler/issues/637}{bundler issues on github}
* November 20 2010, a request on rubygems help, at @{http://help.rubygems.org/discussions/problems/418-rangeerror-when-running-gem-generate_index}{help.rubygems.org}
* November 28 2010, a rails-related question, on @{http://stackoverflow.com/questions/4295033/error-in-installing-bundle-in-rails-application}{stackoverflow.com}
* December 14 2010, when deploying rails with capistrano, on @{http://groups.google.com/group/ruby-bundler/browse_thread/thread/8307e5ffa4fc1cce}{bundler's mailing list}
* February 14 2011, another related issue when installing rspec 2.5.0, reported on @{http://stackoverflow.com/questions/4989618/error-while-installing-rspec-gem-bignum-too-big-to-convert-into-long}{stackoverflow}

