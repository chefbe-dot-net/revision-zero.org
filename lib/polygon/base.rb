module Polygon
  class Base < Sinatra::Base

    configure do
      set :static,        Proc.new { root && root/:content/:static   }
      set :public_folder, Proc.new { root && root/:content/:static   }
      set :dynamic,       Proc.new { root && root/:content/:dynamic  }
      set :templates,     Proc.new { root && root/:design/:templates }
      set :views,         Proc.new { root && root/:design/:templates }
      enable  :logging
      enable  :raise_errors
      disable :show_exceptions
    end

    helpers Polygon::Helpers
  end # Base
end # module Polygon
