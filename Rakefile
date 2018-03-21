$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

desc %q{Regenerates CSS stylesheet} 
task :css do
  Dir.chdir(File.dirname(__FILE__)) do
    `lessc design/stylesheets/1-style.less > public/css/style.css`
    `lessc design/stylesheets/2-highlight.less > public/css/highlight.css`
  end
end

desc %q{Run the website locally}
task :development do
  exec "ruby scripts/launch.rb development"
end

desc %q{Run all tests}
task :test do
  system "bundle exec ruby -Ilib:test test/test_all.rb"
  $?
end

task :default => :test
