require 'case'
class RewritingTest < Case

  def setup
    path = content_folder/"rewriting.yaml"
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
      puts "Checking removal of #{url}"
      get url
      assert_equal 410, 
                   status, 
                   "URL #{url} is marked as removed"
    end
  end

  def test_redirects
    @redirects.each do |h|
      old, new, exp_status = h.values_at("from", "to", "status")
      puts "Checking rewriting of #{old} -> #{new}"

      get old
      assert_equal exp_status || 301, 
                   status, 
                   "URL #{old} is redirected permanently"

      if internal?(new)
        get last_response.headers["Location"]
        assert_equal expected_status(new), 
                     status, 
                     "URL #{new} is a valid new location"
      end
    end
  end

end
