require 'case'
class RevZeroContentTest < Case

  def test_md_files_contain_expected_keys
    dynamic.glob("**/*.md").each do |file|
      h = path2content(file).to_hash
      assert h["title"] != nil, "Writing #{file} has a title"
      assert h["short"] != nil, "Writing #{file} has a short title"
      assert h["date"] != nil, "Writing #{file} has a date"
    end
  end

  def test_categories
    categories = YAML.load((dynamic/"index.yml").read)["categories"]
    dynamic.glob("**/*.md").each do |file|
      h = path2content(file).to_hash
      assert h["category"] != nil, "Writing #{file} has a category"
      assert categories.include?(h["category"]), "Writing #{file} refers to an existing category"
    end
  end

end
