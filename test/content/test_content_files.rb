require 'case'
class ContentFileTest < Case

  def test_yaml_files_are_polygon_readable
    dynamic.glob("**/*.yml").each do |file|
      path2content(file).to_hash
    end
  end

  def test_md_files_are_polygon_readable
    dynamic.glob("**/*.md").each do |file|
      path2content(file).to_hash
    end
  end

end
