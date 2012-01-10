module RevisionZero
  class WebApp < Sinatra::Base
    helpers RevisionZero::Helpers

    ############################################################## Configuration
    configure do
      set :root_folder,      Path.backfind('.[config.ru]')
      set :public_folder,    root_folder/:public
      set :content_folder,   root_folder/:content
      set :templates_folder, root_folder/:templates
      enable  :logging
      enable  :raise_errors
      disable :show_exceptions
    end

    ############################################################## Google routes

    get '/sitemap.xml' do
      content_type "application/xml"
      tpl = settings.templates_folder/"sitemap.whtml"
      ctx = {:files => settings.content_folder.glob("**/index.yml").map{|f|
        def f.to_url
          parent.to_s[(settings.public_folder.to_s.length+1)..-1]
        end
        f
      }}
      WLang::file_instantiate(tpl, ctx)
    end

    ############################################################## Normal routes

    get "/" do
      serve content_for(writings.last["__url__"])
    end

    get %r{^/(.*)} do
      pass unless content = content_for(params[:captures].first)
      serve content
    end

    ########################################################### Rewriting routes

    get // do
      rewriting = YAML.load((settings.content_folder/"rewriting.yaml").read)
      url = request.path
      if entry = rewriting["redirect"].find{|e| e["from"] == url}
        redirect entry["to"], entry["status"] || 301
      elsif entry = rewriting["removed"].include?(url)
        410
      else
        pass
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
