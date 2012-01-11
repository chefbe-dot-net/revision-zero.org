require 'sinatra'
require 'epath'
module Polygon

  def default_loader
    @default_loader ||= ContentLoader.new.enable_all!
  end
  module_function :default_loader

  def default_loader=(loader)
    @default_loader = loader
  end
  module_function :default_loader=

end # module Polygon
require 'polygon/content_loader'
require 'polygon/content'
require 'polygon/helpers'
require 'polygon/base'

