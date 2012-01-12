require 'helper'
module Polygon

  class Content
    public :extensions, :index_files, :parent, :ancestors_or_self
  end

  class ContentTest < Test::Unit::TestCase
    include Helper

    def setup
      @root   = Path.dir/"fixtures"
      @loader = ContentLoader.new
      @loader.enable_yaml!(".yml")
      @loader.enable_yaml_front_matter!(".md")
      @fixtures = Content.new(@root, @loader)
    end

    def test_loader
      assert_equal @loader, @fixtures.loader
    end

    def test_extensions
      assert_equal [".yml", ".md"], @fixtures.extensions
    end

    def test_index_files
      assert_equal @loader.extensions.map{|e| "index#{e}"},
                   @fixtures.index_files
    end

    def test_divide
      assert_equal @root/"index.yml", (@fixtures/"index.yml").path
      assert_equal @fixtures.root, (@fixtures/"index.yml").root
      assert_equal @loader, (@fixtures/"index.yml").loader
    end

    def test_exist?
      assert @fixtures.exist?
      assert (@fixtures/"index.yml").exist?
      assert !(@fixtures/"index.md").exist?
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

    def test_ancestors_or_self
      assert_equal [ @fixtures ], @fixtures.ancestors_or_self
      assert_equal [
        @fixtures/"index.yml",
        @fixtures/"index.md",
        @fixtures/"with_index_yml/index.yml",
        @fixtures/"with_index_yml/index.md",
        @fixtures/"with_index_yml/say-hello.md",
      ], (@fixtures/"with_index_yml/say-hello.md").ancestors_or_self
      assert_equal [
        @fixtures/"index.yml",
        @fixtures/"with_index_yml/index.yml",
        @fixtures/"with_index_yml/say-hello.md",
      ], (@fixtures/"with_index_yml/say-hello.md").ancestors_or_self(true)
    end

    def test_to_hash
      content = @fixtures/"with_index_yml/say-hello.md"

      expected = {
        "title"    => "Say Hello",
        "content"  => "# How to Say Hello to World?\n\nThis way!\n",
        "keywords" => ["say-hello", "with_index_yml/index.yml", "root"],
        "__path__" => content.path,
        "__url__"  => "with_index_yml/say-hello" }
      assert_equal expected, content.to_hash
      assert_equal expected, content.to_hash(true)

      expected = {
        "title"    => "Say Hello",
        "content"  => "# How to Say Hello to World?\n\nThis way!\n",
        "keywords" => ["say-hello"],
        "__path__" => content.path,
        "__url__"  => "with_index_yml/say-hello" }
      assert_equal expected, content.to_hash(false)
    end

   def test_it_splits_md_files_correctly
     content = (@fixtures/"without_index"/"hello.md").to_hash
     assert_equal "Welcome!", content["title"]
     assert_match /^Welcome to/, content["content"]
   end

  end
end
