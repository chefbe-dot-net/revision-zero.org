module RevisionZero
  class WebApp < Sinatra::Base
    helpers RevisionZero::Helpers

    ############################################################## Configuration
    configure do
      set :root_folder,      Path.backfind('.[config.ru]')
      set :public_folder,    root_folder/:content/:static
      set :content_folder,   root_folder/:content/:dynamic
      set :templates_folder, root_folder/:templates
      enable  :logging
      enable  :raise_errors
      disable :show_exceptions
    end
    
    configure(:production) do
      Mail.defaults do
        delivery_method :smtp, { 
         :address   => "localhost",
         :port      => 25,
         :domain    => 'revision-zero.org',
         :user_name => nil,
         :password  => nil,
         :authentication => nil,
         :enable_starttls_auto => false 
        }
      end
    end
    
    configure(:test, :development) do
      Mail.defaults do
        delivery_method :test
      end
    end

    ############################################################## Special routes

    get '/sitemap.xml' do
      content_type "application/xml"
      wlang :sitemap
    end

    get '/rss' do
      content_type "application/rss+xml"
      wlang :rss
    end

    ############################################################## Normal routes

    get "/" do
      serve content_for(writings.last["__url__"])
    end
    
    get %r{^/(-?\d+)} do
      index = params[:captures].first.to_i
      pass unless writing = writings[index]
      serve content_for(writing["__url__"])
    end

    get %r{^/(.*)} do
      pass unless content = content_for(params[:captures].first)
      serve content
    end

    ########################################################### Rewriting routes

    get // do
      rewriting = YAML.load((content_folder/"rewriting.yaml").read)
      url = request.path
      if entry = rewriting["redirect"].find{|e| e["from"] == url}
        redirect entry["to"], entry["status"] || 301
      elsif entry = rewriting["removed"].include?(url)
        410
      else
        pass
      end
    end

    ############################################################## Leaving a comment

    post '/leave-comment' do
      nick, comment, sender, writing = params.values_at("nickname", "comment", "mail", "writing").map{|x|
        (x || "").strip.empty? ? nil : x.strip
      }
      sender ||= "info@revision-zero.org"
      
      unless nick and comment and writing
        400
      else
        Mail.deliver do
             from(sender)
               to("blambeau@gmail.com")
          subject("[revision-zero.org] Comment from #{nick} (#{writing})")
             body(comment)
        end
      end
    end

    ############################################################## Error handling

    # error handling
    error do
      'Sorry, an error occurred'
    end

    ############################################################## Auto start

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
