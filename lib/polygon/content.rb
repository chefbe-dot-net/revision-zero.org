require 'yaml'
require 'epath'
module Polygon
  class Content
    
    # Root of the content folders
    attr_reader :path

    # Underlying content loader
    attr_reader :loader

    # Creates a Content instance
    def initialize(path, loader = Polygon.default_loader)
      @path = path
      @loader = loader
    end

    def entry(path)
      if path.relative?
        path = @path/path
      elsif path.outside?(@path)
        return nil
      end
      Entry.new(self, path)
    end

    class Entry

      # The parent content
      attr_reader :content

      # Path to the file containing this content
      attr_reader :path

      def initialize(content, path)
        @content, @path = content, path
      end

      def exist?
        path.exist?
      end

      def /(arg)
        content.entry(path/arg)
      end

      def ==(other)
        other.is_a?(Entry) and 
        other.content == content and 
        other.path == path
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

      def loader
        content.loader
      end

      def extensions
        loader.extensions
      end

      def index_files
        extensions.map{|ext| "index#{ext}"}
      end

      def parent
        @parent ||= begin
          return nil unless base = self/".."
          idx = -1
          if index?
            idx = index_files.index(path.basename.to_s) - 1
            base = base/".." if idx == -1
          end
          base ? base/index_files[idx] : nil
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
          "__url__"  => path.relative_to(content.path).to_s[0..-(path.extname.length+1)]
        })
      end

    end # class Entry
  end # class Content
end # module Polygon
