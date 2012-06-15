--- 
title: Please Be Kind With My Path, Callee!
short: Be Kind With My Path
date: 2012-06-15 09:06:00 +01:00
category: Ruby
keywords: 
- ruby
---
In almost every ruby project, I end up manipulating paths in some way. If not in the application or the library itself, at least in the tests, for isolating fixtures for example. Paths are everywhere, everytime.

In my opinion, ruby itself provides rather poor tools for manipulating paths: `File.join`, `File.dirname`, `File.extname`, etc. Also `Pathname`, that however belongs to the standard library, not to core. `Pathname` should probably be refactored and enhanced, and is not a very idomatic way to capture paths as far as I know. In the community, the idiomatic way to capture a path seems to be a String, period.

Well, the situation is a bit more complicated. Stuff could hopefully be slightly improved provided we have an agreement on how path are recognized. This post is thus a request for comments about such an agreement!

## A caller/callee contract...

To bring some order here, we must first distinguish between _building paths_ and _using paths_. For instance:

#<{ruby}{
  def callee(path)
    # I'm the callee, I will *use* the path
    ...
  end

  def caller
    # I'm the caller, I *build* a path
    path = ...
    callee(path)
  end
}

At first glance, `Pathname` and the like are mostly tools for building paths. In the example above, how the path is built is the responsibility and secret of the _caller_. The latter may use the tool it wants for the job, provided it passes a path argument recognized by the _callee_. In other words, _caller_ and _callee_ must have an agreement on how `path` captures a path. When they are both in the same program or library, it is a matter of internal conventions. However, passing paths across gem boundaries is very common, so the agreement should be broader.

Most callees expect a path to be passed as a String. This is not ideal, for at least two reasons:

* It is not necessarily friendly. If the latter commonly works with `Pathname`, it must take great care of always calling `:to_s` before passing paths to the outside world.
* It tends to restrict APIs in situations where String must be logically distinguished from Path (see the Citrus example in next section, for example).

Nicer conventions are in used here and there, but no real agreement seems to emerge, at least not one that I'm really aware of. Let look at different examples.

## Different conventions in use

In @{https://github.com/rtomayko/tilt}{Tilt} for instance, paths seem to be those instances that respond to `:to_str`. In complex method signatures, for example, it @{https://github.com/rtomayko/tilt/blob/1.3.3/lib/tilt/template.rb#L43}{recognizes a path as follows}:

#<{ruby}{
  def build_template(*args)
    path = args.find{ |arg| arg.respond_to?(:to_str) }
    ...
  end
}

Note that a later commit (but not the current release, 1.3.3 as today) let Tilt's master @{https://github.com/rtomayko/tilt/blob/10a8ffa0a83f0c38dd243549fa9a32a2e76be6bd/lib/tilt/template.rb#L43-44}{recognize paths via `:path` as well}:

#<{ruby}{
  def build_template(*args)
    path = args.find{ |arg| arg.respond_to?(:to_str) or arg.respond_to?(:path) }
    ...
  end
}

In ruby 1.9.x, `Pathname` itself seems to use a different convention:

#<{ruby}{
  RUBY_VERSION
  # => "1.9.2" 

  Pathname.new('foo').path
  # => NoMethodError: undefined method `path' for #<Pathname:foo>

  Pathname.new('foo').to_path
  # => "foo" 
}

In @{https://github.com/mjijackson/citrus}{Citrus}, Mickael Jackson's parsing expressions library, paths are expected to respond to `:to_path`. More precisely, I made a contribution that allows @{https://github.com/mjijackson/citrus/blob/0edd8e661bed22809d233849ae50f7eab81c7a7f/lib/citrus.rb#L273-284}{passing a path} instead of the text to parse itself. At that time, I thought that `:to_path` was standard in ruby 1.9 because of Pathname, so I coded something like this:

#<{ruby}{
  def parse(parsable)
    if parsable.respond_to(:to_path)
      @source = File.read(source.to_path)
    else
      @source = parsable.to_s
    end
  end
}

@{https://github.com/eregon/epath}{Benoit Daloze's path manipulation library}, that I use almost everyday, implements both `:path` and `:to_path`. Unfortunately, it does not work out of the box with the current release of Tilt:

#<{ruby}{
  Path('foo').to_str
  # => NoMethodError: undefined method `to_str' for #<Path foo>  
}

More recently, in a pull request to @{https://github.com/sinatra/sinatra}{Sinatra}, I naturally ended up @{https://github.com/blambeau/sinatra/blob/53846acac5e1d587690cfe32b9c1ac54ffcc3713/lib/sinatra/base.rb#L756-761}{with the following logic}:

#<{ruby}{
  def path_as_string(path)
    path   = view.path    if view.respond_to?(:path)
    path ||= view.to_path if view.respond_to?(:to_path)
    path ||= view.to_s    # even more permissive than :to_str here
    path  
  end
}

## Conclusion

I'm a bit lost now. Is there an agreement somewhere, in ruby core maybe? What do you think? Should we agree on some standard way to recognize paths? Which one? 

In the long run, I would also be in favor of having a Path class inside ruby core itself. Not in the standard library, in the core. We use paths everywhere and everytime. I would vote for @{https://github.com/eregon/epath#path---a-path-manipulation-library}{Benoit Daloze's Path abstraction}, but that's not really important ;-)