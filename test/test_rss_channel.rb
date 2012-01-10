require 'case'
class RssChannelTest < Case

  def setup
    super
    @rss ||= begin
      get '/rss'
      assert_equal 200, status, "/rss should respond"
      body
    end
  end

  def test_it_has_the_valid_content_type
    assert_match %r{application/rss\+xml}, content_type, "rss should be application/rss+xml"
  end
  
  def test_it_returns_the_last_writings
    titles = body.scan(%r{<title>(.*?)</title>}).map(&:first)
    assert_equal ["www.revision-zero.org"] + writings[-5..-1].reverse.map{|h| h["title"]}, titles
  end

end