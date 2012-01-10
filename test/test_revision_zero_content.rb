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

end
