require 'test/unit'
require 'epath'
require 'polygon'
module Polygon
  class ContentTest < Test::Unit::TestCase

    def setup
      @root = Path.dir/"fixtures"
      @fixtures = Content.new(@root, @root)
    end

    def test_find
      assert_equal @fixtures/"index.yml", Content.find(@root, "")
      assert_equal @fixtures/"index.yml", Content.find(@root, "index")
      assert_equal @fixtures/"with_index_yml/index.yml", Content.find(@root, "with_index_yml")
      assert_equal @fixtures/"with_index_yml/say-hello.md", Content.find(@root, "with_index_yml/say-hello")
      assert_equal @fixtures/"with_index_md/index.md", Content.find(@root, "with_index_md")
      assert_nil Content.find(@root, "without_index")
      assert_nil Content.find(@root, "no-such-one")
    end

    def test_parent
      assert_nil @fixtures.parent
      assert_nil (@fixtures/"index.yml").parent
      assert_equal @fixtures/"index.yml", (@fixtures/"index.md").parent
      assert_equal @fixtures/"index.md", (@fixtures/"say-hello.md").parent
      assert_equal @fixtures/"index.md", (@fixtures/"with_index_yml").parent
      assert_equal @fixtures/"with_index_yml/index.md", (@fixtures/"with_index_yml/say-hello.md").parent
      assert_equal @fixtures/"index.md", (@fixtures/"with_index_md").parent
      assert_equal @fixtures/"with_index_md/index.yml", (@fixtures/"with_index_md/index.md").parent
    end

    def test_parent_or_self
      assert_equal [ @fixtures ], @fixtures.parent_or_self
      assert_equal [
        @fixtures/"index.yml",
        @fixtures/"index.md",
        @fixtures/"with_index_yml/index.yml",
        @fixtures/"with_index_yml/index.md",
        @fixtures/"with_index_yml/say-hello.md",
      ], (@fixtures/"with_index_yml/say-hello.md").parent_or_self
      assert_equal [
        @fixtures/"index.yml",
        @fixtures/"with_index_yml/index.yml",
        @fixtures/"with_index_yml/say-hello.md",
      ], (@fixtures/"with_index_yml/say-hello.md").parent_or_self(true)
    end

    def test_to_h
      content = @fixtures/"with_index_yml/say-hello.md"
      h = {
        "title" => "Say Hello",
        "text"  => "# How to Say Hello to World?\n\nThis way!\n",
        "keywords" => ["say-hello", "with_index_yml/index.yml", "root"],
        "__path__" => content.path,
        "__url__"  => "with_index_yml/say-hello" }
      assert_equal h, content.to_h
    end
  
    def test_it_splits_md_files_correctly
      content = (@fixtures/"without_index"/"hello.md").to_h
      assert_equal "Welcome!", content["title"]
      assert_match /^Welcome to/, content["text"]
    end

  end
end