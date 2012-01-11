require 'case'
class GoogleFilesTest < Case

  def test_robots_txt
    head '/robots.txt'
    assert_equal 200, status, "robots.txt should respond"
    assert_match %r{text/plain}, content_type, "robots.txt should be text/plain"
  end

  def test_sitemap
    head '/sitemap.xml'
    assert_equal 200, status, "sitemap.xml should respond"
    assert_match %r{application/xml}, content_type, "sitemap.xml should be application/xml"
  end

end
