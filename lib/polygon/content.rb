require 'yaml'
require 'epath'
module Polygon
  class Content

    # Path to the file containing this content
    attr_reader :path

    # Root of the content folders
    attr_reader :root

    # Underlying content loader
    attr_reader :loader

    def initialize(path, loader = Polygon.default_loader, root = nil)
      root    = (path.directory? ? path : path.parent) if root.nil?
      @path   = path
      @root   = root
      @loader = loader
    end

    def exist?
      path.exist?
    end

    def /(arg)
      Content.new(path/arg, loader, root)
    end

    def ==(other)
      other.is_a?(Content) && other.path == path
    end

    def to_s
      path.to_s
    end

    def to_hash(with_ancestors = true)
      if with_ancestors
        ancestors_or_self(true).inject({}) do |h,content|
          merge(h, content.data)
        end
      else
        data
      end
    end

    protected

    def extensions
      loader.extensions
    end

    def index_files
      extensions.map{|ext| "index#{ext}"}
    end

    def parent
      @parent ||= begin
        base, idx = self/"..", -1
        if index?
          idx = index_files.index(path.basename.to_s) - 1
          base = base/".." if idx == -1
        end
        base.path == root.parent ? nil : base/index_files[idx]
      end
    end

    def ancestors_or_self(filter = false)
      res = _ancestors_or_self
      filter ? res.select{|f| f.path.exist?} : res
    end

    def _ancestors_or_self
      return [ self ] unless parent
      parent.ancestors_or_self + [ self ]
    end

    def index?
      index_files.include?(path.basename.to_s)
    end

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
      loader.load(path).merge({
        "__path__" => path, 
        "__url__"  => path.relative_to(root).to_s[0..-(path.extname.length+1)]
      })
    end

  end # class Content
end # module Polygon
