module RevisionZero
  module Helpers

    def content_loader
      Polygon::ContentLoader.new.
        enable_yaml!(".yml").
        enable_yaml_front_matter!(".md")
    end

    def root_content
      Polygon::Content.new(dynamic, content_loader)
    end

    def path2content(path)
      path && Polygon::Content.new(path, content_loader, dynamic)
    end

    def url2path(url)
      content_loader.extensions.each do |ext| 
        file = dynamic/"#{url}#{ext}"
        return file if file.file?
      end
      content_loader.extensions.each do |ext| 
        file = dynamic/url/"index#{ext}"
        return file if file.file?
      end
      nil
    end

    def url2content(url)
      path2content(url2path(url))
    end

    def writings
      dynamic.glob("**/*.md").map{|file|
        path2content(file).to_hash
      }.sort{|h1,h2| h1["date"] <=> h2["date"]}
    end

    def default_context(content = nil)
      ctx = {
        "writings"   => writings, 
        "environment" => settings.environment
      }
      ctx.merge!(content.to_hash) if content
      ctx
    end

    def wlang(tpl, ctx = default_context)
      tpl = templates/"#{tpl}.whtml" if tpl.is_a?(Symbol)
      WLang::file_instantiate tpl, ctx
    end

    def serve(content)
      wlang :html, default_context(content)
    end

  end # module Helpers
end # module RevisionZero
