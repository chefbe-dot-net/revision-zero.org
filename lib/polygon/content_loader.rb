module Polygon
  class ContentLoader

    def register(*extensions, &loader)
      raise ArgumentError, "Extensions expected" if extensions.empty?
      loaders << [extensions, loader]
      self
    end

    def extensions
      loaders.map(&:first).flatten
    end

    def load(file)
      file = Path(file)
      unless l = loader(file)
        raise "Unable to load #{file.basename} (unrecognized extension)" 
      end
      l.call(file)
    end

    ################################################################### Loaders

    def enable_yaml!(*ext)
      require 'yaml'
      ext = [".yml", ".yaml"] if ext.empty?
      register(*ext) do |f| 
        YAML.load(f.read) 
      end
    end

    def enable_json!(*ext)
      require 'json'
      ext = [".json"] if ext.empty?
      register(*ext) do |f| 
        JSON.load(f.read) 
      end
    end

    def enable_ruby!(*ext)
      ext = [".rb", ".ruby"] if ext.empty?
      register(*ext) do |f| 
        ::Kernel.eval(f.read, TOPLEVEL_BINDING, f.to_s) 
      end
    end

    def enable_yaml_front_matter!(*ext)
      ext = [".md"] if ext.empty?
      register(*ext) do |f| 
        content = f.read
        if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          YAML::load($1).merge("content" => $')
        else
          {"content" => content}
        end
      end
    end

    def enable_all!
      enable_yaml!
      enable_json!
      enable_ruby!
      enable_yaml_front_matter!
    end

    private

    def loaders
      @loaders ||= []
    end

    def loader(file, extname = Path(file).extname)
      loader = loaders.find{|ext,_| ext.include?(extname)}
      loader && loader.last
    end

  end # class ContentLoader
end # module Polygon
