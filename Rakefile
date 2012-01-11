$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

desc %q{Regenerates CSS stylesheet} 
task :css do
  Dir.chdir(File.dirname(__FILE__)) do
    `lessc design/stylesheets/*.less > public/css/style.css`
  end
end

desc %q{Run the website locally}
task :development do
  exec "ruby scripts/launch.rb development"
end

namespace :test do

  desc %q{Test polygon helpers}
  task :polygon do
    system "bundle exec ruby -Ilib -Itest test/polygon/runall.rb"
  end

  desc %q{Test content}
  task :content do
    system "bundle exec ruby -Ilib -Itest test/content/runall.rb"
  end

  desc %q{Test services}
  task :service do
    system "bundle exec ruby -Ilib -Itest test/service/runall.rb"
  end

  desc %q{Test controllers}
  task :controllers do
    system "bundle exec ruby -Ilib -Itest test/controllers/runall.rb"
  end

  task :all => [:content, :service, :controllers, :polygon]
end

task :default => "test:all".to_sym
