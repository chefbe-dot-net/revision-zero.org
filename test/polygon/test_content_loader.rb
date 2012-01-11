require 'helper'
module Polygon
  class ContentLoaderTest < Test::Unit::TestCase
    include Helper

    def setup
      @loader = ContentLoader.new
      @loader.enable_all!
    end

    def test_load
      fixtures = Path.dir/:fixtures/:data

      assert_equal({"kind" => "yml"},  @loader.load(fixtures/"data.yml"))
      assert_equal({"kind" => "yaml"}, @loader.load(fixtures/"data.yaml"))
      assert_equal({"kind" => "json"}, @loader.load(fixtures/"data.json"))
      assert_equal({"kind" => "rb"},   @loader.load(fixtures/"data.rb"))
      assert_equal({"kind" => "ruby"}, @loader.load(fixtures/"data.ruby"))

      assert_equal({"kind" => "md", "content" => "This is the text"}, 
                   @loader.load(fixtures/"data.md"))
      assert_equal({"content" => "This is the text"}, 
                   @loader.load(fixtures/"text.md"))

      assert_raise(Errno::ENOENT){ 
        @loader.load(fixtures/"no-such-one.yml") 
      }
      assert_raise(RuntimeError, /Unable to load.*unrecognized extension/){ 
        @loader.load(fixtures/"data.notarecognized") 
      }
    end

    def test_extensions
      assert_equal [".yml", ".yaml", ".json", ".rb", ".ruby", ".md"],
                   @loader.extensions
    end

  end
end
