Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"

# set development environment and launch dependencies
ENV["RACK_ENV"] = "production"
require 'bundler'
Bundler.setup(:production)

# chdir to root now
Dir.chdir(root = File.expand_path('../../',__FILE__)) do
  # update loadpath and load project
  $: << File.join(root,"lib")
  require 'revision_zero'
  
  # main appplication
  map '/' do
    run RevisionZero::WebApp
  end

  # websync
  map '/websync/redeploy' do
    run lambda{|env|
      begin
        Bundler::with_original_env do 
          require 'revision_zero/server_agent'
          agent = RevisionZero::ServerAgent.new(root)
          agent.signal(:"redeploy-request")
          [ 200, 
           {"Content-type" => "text/plain"},
           [ "Ok" ] ]
        end
      rescue Exception => ex
        [ 500, 
         {"Content-type" => "text/plain"},
         [ ex.message + "\n" + ex.backtrace.join("\n") ] ]
      end
    }
  end
end

