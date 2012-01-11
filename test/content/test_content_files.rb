require 'case'
class ContentFileTest < Case

  def test_yaml_files_are_polygon_readable
    dynamic_folder.glob("**/*.yml").each do |file|
      assert_nothing_raised{ Polygon::Content.new(file).to_h }
    end
  end

  def test_md_files_are_polygon_readable
    dynamic_folder.glob("**/*.md").each do |file|
      assert_nothing_raised{ Polygon::Content.new(file).to_h }
    end
  end

end
