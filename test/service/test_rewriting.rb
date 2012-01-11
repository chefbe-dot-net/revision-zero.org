require 'case'
class RewritingTest < Case

  def setup
    path = dynamic/"rewriting.yaml"
    @rewriting = YAML.load(path.read)
    @redirects = Array(@rewriting["redirect"])
    @removed   = Array(@rewriting["removed"])
  end

  def expected_status(x)
    if @removed.include?(x)
      410
    elsif h = @redirects.find{|h| h["from"] == x}
      h["status"] || 301
    else
      200
    end
  end

  def test_removals
    @removed.each do |url|
      head url
      assert_equal 410, status, 
                   "URL #{url} is marked as removed"
    end
  end

  def test_redirects
    @redirects.each do |h|
      oldone, newone, exp_status = h.values_at("from", "to", "status")

      head oldone
      assert_equal exp_status || 301, status, 
                   "URL #{oldone} is redirected permanently"

      if internal?(newone)
        head last_response.headers["Location"]
        assert_equal expected_status(newone), status, 
                     "URL #{newone} is a valid new location"
      end
    end
  end

end
