Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"
require 'case'
Dir[File.join(File.dirname(__FILE__), "**/test_*.rb")].each do |f|
  load(f)
end
