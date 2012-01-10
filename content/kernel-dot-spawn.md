--- 
title: Kernel.spawn
short: Kernel.spawn
date: 2011-01-18 09:19:00 +01:00
category: Ruby
keywords: 
- ruby
- Kernel
- shell
---
Ruby 1.9 comes with new methods to execute a (shell) command, namely @{http://www.ruby-doc.org/core/classes/Kernel.html#M001442}{@Kernel.spawn@} also available as @{http://ruby-doc.org/core-1.9/classes/Process.html#M002230}{@Process.spawn@}. In a few words, @Kernel.spawn@ is the powerful tool hidden behind @{http://www.ruby-doc.org/core/classes/Kernel.html#M001408}{@Kernel.`@}, @{http://www.ruby-doc.org/core/classes/Kernel.html#M001438}{@Kernel.exec@}, and @{http://www.ruby-doc.org/core/classes/Kernel.html#M001441}{@Kernel.system@}. If your feeling is that the latter methods, as well as @{http://www.ruby-doc.org/core/classes/IO.html#M000880}{@IO.popen@} are sometimes too restrictive, @{http://www.ruby-doc.org/core/classes/Kernel.html#M001442}{@Kernel.spawn@} is probably for you.

Note: these methods have *not* been backported in Ruby 1.8.x, but you can still use them thanks to the @{https://rubygems.org/gems/sfl}{sfl gem} (source code available on @{https://github.com/ujihisa/spawn-for-legacy)}{github}. Note that the compatibility coverage of the latter gem is far from 100%. Anyway, all examples below are supported by the 2.0 version.

### Quick overview

The new `spawn` method comes with a lot of options *set environment variables* for the subprocess, *change the current directory*, *redirect file descriptors* (i.e. standard input and output), and so on. In all cases it *doesn‘t wait for end of the command* but *returns the pid* of the subprocess. Therefore, you'll have to use @{http://www.ruby-doc.org/core/classes/Process.html#M001287}{@Process.wait@} or @{http://www.ruby-doc.org/core/classes/Process.html#M001292}{@Process.detach@} on the resulting pid. Below are listed typical use cases.

#### Redirecting

By default, standard file descriptors (i.e. standard input, output and error) will be shared with the calling process. Redirecting them is really simple however, as illustrated below. Be warned however that *the `IO` object must be a real `IO` object*. In other words, retrieving the process output via a `StringIO` will not work properly...

#<{kernel_dot_spawn/example1.rb}

Interestingly, you can also redirect to files directly:

#<{kernel_dot_spawn/example2.rb}

#### Closing

It may happen that the subprocess is too verbose and interfers with the output of your own process, by printing debuging information on the standard output for example... In this case, you would like to simply close the subprocess output:

#<{kernel_dot_spawn/example3.rb}

#### Changing current directory of the callee

Another interesting use case: some sub processes may expect being located in a specific location. Not difficult either:

#<{kernel_dot_spawn/example4.rb}

### Going further

I've not seen many blog entries about @Kernel.spawn@, which is the reason I've written this post (more to bring that powerful method to your attention than to be exhaustive). I've covered only a few use cases and options, refer to the @{http://www.ruby-doc.org/core/classes/Kernel.html#M001442}{official documentation} for details. Remember that the @{https://github.com/ujihisa/spawn-for-legacy}{sfl gem} does not provide 100% coverage, even if examples listed above should work properly using its 2.0 release!