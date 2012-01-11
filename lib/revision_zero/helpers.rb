module RevisionZero
  module Helpers

    [ :root_folder, 
      :dynamic_folder, 
      :public_folder, 
      :templates_folder ].each do |methname|
      define_method(methname) do
        settings.send(methname)
      end
    end

    def writings
      dynamic_folder.glob("**/*.md").map{|file|
        Polygon::Content.new(file).to_h
      }.sort{|h1,h2| h1["date"] <=> h2["date"]}
    end
    
    def default_context(content = nil)
      ctx = {
        "writings"   => writings, 
        "environment" => settings.environment
      }
      ctx.merge!(content.to_h) if content
      ctx
    end
    
    def content_for(url)
      Polygon::Content.find(dynamic_folder, url)
    end

    def wlang(tpl, ctx = default_context)
      tpl = templates_folder/"#{tpl}.whtml" if tpl.is_a?(Symbol)
      WLang::file_instantiate tpl, ctx
    end

    def serve(content)
      wlang :html, default_context(content)
    end

  end # module Helpers
end # module RevisionZero
