#!/usr/bin/env ruby
require_relative 'script'
class GSub < Script(__FILE__, __LINE__)

  attr_accessor :dry_run, :regexp, :folder, :pattern

  options do |opt|
    self.enable_logging = false
    opt.on('--[no-]log', "Properly log in a file?") do |value|
      self.enable_logging = value
    end
    self.dry_run = false
    opt.on('-d', '--dry-run', "Dry-run mode, do not touch files") do
      self.dry_run = true
    end
    self.regexp = false
    opt.on('-r', '--regexp', "Use `from` as a regular expression") do
      self.regexp = true
    end
    self.pattern = "**/*.*"
    opt.on('-g', '--glob=PATTERN', "File pattern to use for Path.glob") do |pattern|
      self.pattern = pattern
    end
    self.folder = Path(".")
  end

  # Stolen from ptools (https://github.com/djberg96/ptools)
  def binary?(file)
    s = (File.read(file, File.stat(file).blksize) || "").split(//)
    ((s.size - s.grep(" ".."~").size) / s.size.to_f) > 0.30
  end

  def gsub(file, from, to)
    gsubbed = file.read.gsub!(from){|m| 
      msg = "gsub #{m[0, (50 - to.length)]} -> #{to}"
      msg += " "*(60 - msg.length) + " (#{file})" 
      info msg 
      to
    }
    file.write(gsubbed) if gsubbed && !dry_run
  rescue ArgumentError => ex
    error "Skipping #{file}: #{ex.message}"
  end

  def execute(args)
    abort options.to_s unless args.size >= 2
    from     = args.shift
    from     = Regexp.compile(regexp ? from : Regexp.escape(from))
    to       = args.shift
    files    = args.empty? ? folder.glob(pattern) : args.map(&Path)
    files.each do |file|
      next if file.directory? or binary?(file)
      gsub(file, from, to)
    end
  end

  run(ARGV) if $0 == __FILE__
end