require 'yaml'
require 'logger'
require 'uri'

require 'redcarpet'
require 'epath'
require 'albino'
require 'mail'
require 'polygon'
require 'sinatra/base'

module RevisionZero

  STARTED_AT = Time.now

  def internal?(url)
    url && !(url =~ /^(https?|ftp|mailto):/) && !(url =~ /ajax.googleapis.com/)
  end
  module_function :internal?

  def external?(url)
    !internal?(url)
  end
  module_function :external?

  def makelink(url, label = url)
    label = url unless label
    if external?(url)
      %Q{<a target="_blank" href="#{url}">#{label}</a>}
    else
      %Q{<a href="#{url}">#{label}</a>}
    end
  end
  module_function :makelink

end
require 'revision_zero/ext/hash'
require 'revision_zero/ext/cache_control'
require 'revision_zero/ext/wlang'
require 'revision_zero/helpers'
require 'revision_zero/webapp'
