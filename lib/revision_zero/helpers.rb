require 'content'
module RevisionZero
  module Helpers

    def writings
      settings.content_folder.glob("**/*.md").map{|file|
        Content.new(file).to_h
      }.sort{|h1,h2| h1["date"] <=> h2["date"]}
    end

    def default_context
      {"writings" => writings, "environment" => settings.environment}
    end
    
    def content_for(url)
      Content.find(settings.content_folder, url)
    end

    def serve(content)
      ctx = default_context.merge(content.to_h)
      WLang::file_instantiate settings.templates_folder/"html.whtml", ctx
    end

  end # module Helpers
end # module RevisionZero
