require 'fileutils'
require 'epath'
require 'yaml'
require 'time'

def normalize(text)
  text.gsub!(/^#\s/,"1. ")
  text.gsub!(/!!\{\*(.*?)\*\}/) do |match|
    "!!{#{$1}}"
  end
  text.gsub!(/^p\=\. ?!@{(.*?)}!/) do |match|
    "![](#{$1})"
  end
  text.gsub!(/!@{(.*?)}!/) do |match|
    "![](#{$1})"
  end
  text.gsub!(/^p\=\. ?(.*?)\n/) do |match|
    "<center>#{$1.strip}</center>\n"
  end
  text.gsub!(/@([a-zA-Z0-9\s]+)@/) do |match|
    "`#{$1}`"
  end
#  text.gsub!(/\*([a-zA-Z0-9\s]+)\*/) do |match|
#    "**#{$1}**"
#  end
  text.gsub!(/^h(\d)\./) do |match|
    "#" * $1.to_i
  end
  text.gsub!(%r{"(.*?)":([^\s]+)}) do |match|
    href, label, after = $2, $1, ""
    if href =~ /[^a-zA-Z0-9\/]$/
      href, after = href[0...-1], href[-1..-1]
    end
    "@{#{href}}{#{label}}#{after}"
  end
  text
end

articles = Path.dir/'../../../blambeau.github.com/src/articles'
writings = YAML.load((articles/"writings.yaml").read)["writings"]
Path(articles).glob("*.r0").each do |source|
  basename = File.basename(source, ".r0")
  newname  = basename.gsub('_', '-')
  target   = Path.dir/"../content/#{newname}.md"

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
