ENV["RACK_ENV"] = "test"
require 'revision_zero'
require 'test/unit'
require 'rack/test'
class Case < Test::Unit::TestCase
  include Rack::Test::Methods
  include RevisionZero::Helpers

  def app
    RevisionZero::WebApp
  end
  alias :settings :app

  def internal?(link)
    link && !(link =~ /^(https?|ftp|mailto):/) && !(link =~ /ajax.googleapis.com/)
  end

  [:status, :content_type, :body].each do |methname|
    define_method(methname) do |*args, &bl|
      last_response.send(methname, *args, &bl)
    end
  end

end
