require 'case'
class SpecialRoutesTest < Case

  def test_root_url
    get '/'
    assert_equal 200, status, "/ should respond"
    assert_equal writings.last["title"], body[%r{<title>(.*)</title>}, 1]
  end

  def test_root_url
    get '/-1'
    assert_equal 200, status, "/-1 should respond"
    assert_equal writings.last["title"], body[%r{<title>(.*)</title>}, 1]
  end
  
  def test_0_index
    get '/0'
    assert_equal 200, status, "/0 should respond"
    assert_equal writings.first["title"], body[%r{<title>(.*)</title>}, 1]
  end

end
