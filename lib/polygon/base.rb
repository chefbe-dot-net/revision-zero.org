module Polygon
  class Base < Sinatra::Base

    configure do
      set :public_folder,    Proc.new { root && root/:content/:static   }
      set :dynamic_folder,   Proc.new { root && root/:content/:dynamic  }
      set :templates_folder, Proc.new { root && root/:design/:templates }
      enable  :logging
      enable  :raise_errors
      disable :show_exceptions
    end

    helpers do

    end

  end # Base
end # module Polygon
