require 'yaml'
require 'epath'
module Polygon
  class Content

    class << self

      LOADERS = {}
    
      def register(*extensions, &loader)
        LOADERS.merge! Hash[extensions.map{|ext| [ext, loader]}]
      end

      def loader(file)
        LOADERS[Path(file).extname]
      end
      
      def read(file)
        file = Path(file)
        raise "Unable to load #{file.basename} (unrecognized extension)" unless l = loader(file)
        l.call(file)
      end
      
      def load_md_content(f)
        content = f.read
        if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          YAML::load($1).merge("text" => $')
        else
          {"text" => content}
        end
      end
      
    end
    self.register(".yml", ".yaml"){|f| require 'yaml'; YAML.load(f.read)               }
    self.register(".json")        {|f| require 'json'; JSON.load(f.read)               }
    self.register(".rb", ".ruby") {|f| ::Kernel.eval(f.read, TOPLEVEL_BINDING, f.to_s) }
    self.register(".md")          {|f| self.load_md_content(f)                         }

    EXTENSIONS  = [".yml", ".md"]
    INDEX_FILES = EXTENSIONS.map{|ext| "index#{ext}"}

    attr_reader :root
    attr_reader :path

    def initialize(path, root = nil)
      root = (path.directory? ? path : path.parent) if root.nil?
      @path, @root = path, root
    end

    # Finds a content
    def self.find(root, offset)
      EXTENSIONS.reverse.each do |ext| 
        path = root/"#{offset}#{ext}"
        return Content.new(path, root) if path.exist?
      end
      INDEX_FILES.reverse.each do |index|
        path = root/offset/index
        return Content.new(path, root) if path.exist?
      end
      nil
    end

    # Returns the parent content
    def parent
      @parent ||= begin
        base, idx = self/"..", -1
        if index?
          idx = INDEX_FILES.index(path.basename.to_s) - 1
          base = base/".." if idx == -1
        end
        base.path == root.parent ? nil : base/INDEX_FILES[idx]
      end
    end

    # Returns all parents or self
    def parent_or_self(filter = false)
      res = _parent_or_self
      filter ? res.select{|f| f.exist?} : res
    end

    # Internal implementation of parent_or_self
    def _parent_or_self
      return [ self ] unless parent
      parent.parent_or_self + [ self ]
    end


    # Delegated to Path
    [:file?, :directory?, :exist?].each do |me|
      define_method(me) do |*args, &bl|
        path.send(me, *args, &bl)
      end
    end

    # True if an index file
    def index?
      INDEX_FILES.include?(path.basename.to_s)
    end

    # Delegated to Path, but returns a Content instance
    def /(arg)
      Content.new(path/arg, root)
    end

    # Checks equality with another Content instance. Equality testing is 
    # based on the underlying path.
    def ==(other)
      other.is_a?(Content) && other.path == path
    end

    def to_s
      path.to_s
    end

    def to_h
      parent_or_self(true).inject({}) do |h,content|
        merge(h, content.data)
      end
    end

    protected

    def merge(left, right)
      raise "Unexpected #{left.class} vs. #{right.class}" \
        unless left.class == right.class
      case left
      when Array
        (right | left).uniq
      when Hash
        left.merge(right){|k,l,r|
          merge(l,r)
        }
      else
        right
      end
    end

    def data
      Content.read(path).merge({
        "__path__" => path, 
        "__url__"  => path.relative_to(root).to_s[0..-(path.extname.length+1)]
      })
    end

  end # class Content
end # module Polygon