require 'content'
module RevisionZero
  module Helpers

    [ :root_folder, 
      :content_folder, 
      :public_folder, 
      :templates_folder ].each do |methname|
      define_method(methname) do
        settings.send(methname)
      end
    end

    def writings
      content_folder.glob("**/*.md").map{|file|
        Content.new(file).to_h
      }.sort{|h1,h2| h1["date"] <=> h2["date"]}
    end

    def default_context(content = nil)
      ctx = {"writings" => writings, "environment" => settings.environment}
      ctx.merge!(content.to_h) if content
      ctx
    end
    
    def content_for(url)
      Content.find(content_folder, url)
    end

    def serve(content)
      WLang::file_instantiate templates_folder/"html.whtml", default_context(content)
    end

  end # module Helpers
end # module RevisionZero
