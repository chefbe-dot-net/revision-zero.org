require 'case'
class IndexPageTest < Case

  def setup
    get '/'
  end

  def test_it_should_succeed
    assert_equal 200, status, "Index page should respond"
    assert_match %r{text/html}, content_type, "Index should be text/html"
  end

  def test_stylesheets_should_respond
    body.scan %r{<link.*?href="(.*?)"} do |match|
      head (css = match.first)
      next unless internal?(css)
      assert_equal 200, status, "Stylesheet #{css} should respond"
      assert_match %r{text/css}, content_type, "Stylesheet #{css} should be text/css"
    end
  end

  def test_javascripts_should_respond
    body.scan %r{<script.*src="(.*?)"} do |match|
      head (js = match.first)
      next unless internal?(js)
      assert_equal 200, status, "Script #{js} should respond"
      assert_match %r{application/javascript}, content_type, "Javascript #{js} should be application/javascript"
    end
  end

end
