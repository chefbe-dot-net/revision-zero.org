require 'fileutils'
require 'epath'
require 'yaml'
require 'time'

content = Path.backfind(".[config.ru]")/"content"
content.glob("*.md").each do |file|
  text = file.read
  text.gsub!(/^###\s+/, "## ")
  text.gsub!(/^####\s+/, "### ")
  file.write(text)
end
