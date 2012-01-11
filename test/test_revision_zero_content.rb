require 'case'
class RevZeroContentTest < Case

  def test_md_files_contain_expected_keys
    content_folder.glob("**/*.md").each do |file|
      h = Content.new(file).to_h
      assert_not_nil h["title"], "Writing #{file} has a title"
      assert_not_nil h["short"], "Writing #{file} has a short title"
      assert_not_nil h["date"], "Writing #{file} has a date"
    end
  end

  def test_categories
    categories = YAML.load((content_folder/"index.yml").read)["categories"]
    content_folder.glob("**/*.md").each do |file|
      h = Content.new(file).to_h
      assert_not_nil h["category"], "Writing #{file} has a category"
      assert categories.include?(h["category"]), "Writing #{file} refers to an existing category"
    end
  end

end
