require 'fileutils'
require 'epath'
require 'yaml'
require 'time'

def debug(match, res)
  puts "Replacing #{match} -> #{res}"
  res
end

def normalize(text)
  text.gsub!(/^#\s/) do |match|
    debug(match, "1. ")
  end
  text.gsub!(/!!\{(.*?)\}/m) do |match|
    text = $1
    text = text[1...-1] if text =~ /^\*(.*)\*$/
    text = "> " + text.split("\n").join("\n> ")
    debug(match, text)
  end
  text.gsub!(/^p\=\. ?!@{(.*?)}!/) do |match|
    debug(match, "![](#{$1})")
  end
  text.gsub!(/@(?![\{\?\s])([^@\n]+)@/) do |match|
    debug(match, "`#{$1}`")
  end
  text.gsub!(/!@{(.*?)}!/) do |match|
    debug(match, "![](#{$1})")
  end
  text.gsub!(/^p\=\. ?(.*?)\n/) do |match|
    debug(match, "<center>#{$1.strip}</center>\n")
  end
  text.gsub!(/^h(\d)\./) do |match|
    debug(match, "#" * $1.to_i)
  end
  text.gsub!(/"(.*?)":([^\s]+)/) do |match|
    href, label, after = $2, $1, ""
    if href =~ /[^a-zA-Z0-9\/]$/
      href, after = href[0...-1], href[-1..-1]
    end
    debug(match, "@{#{href}}{#{label}}#{after}")
  end
  text
end

articles = Path.dir/'../../../blambeau.github.com/src/articles'
writings = YAML.load((articles/"writings.yaml").read)["writings"]
Path(articles).glob("*.r0").each do |source|
  basename = File.basename(source, ".r0")
  newname  = basename.gsub('_', '-')
  target   = Path.dir/"../content/#{newname}.md"
  next if basename =~ /404|reuse_in_practice/

  info     = writings.find{|w| w["identifier"] == basename} || {}
  info["short"] = info["title"] unless info["short"]
  info["date"]  = Time.parse(info["date"], "yyyy/mm/dd -- hh:mm") if info["date"]
  info.delete("identifier")

  #puts "#{source} -> #{target}" 
  File.open(target, "w") do |io|
    io << info.to_yaml
    io << "---\n"
    io << normalize(source.read)
  end
end
