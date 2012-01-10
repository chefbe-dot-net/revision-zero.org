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

    def default_context
      {"writings" => writings, "environment" => settings.environment}
    end
    
    def content_for(url)
      Content.find(content_folder, url)
    end

    def serve(content)
      ctx = default_context.merge(content.to_h)
      WLang::file_instantiate templates_folder/"html.whtml", ctx
    end

  end # module Helpers
end # module RevisionZero
