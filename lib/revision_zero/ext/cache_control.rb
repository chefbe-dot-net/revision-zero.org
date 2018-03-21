module Rack
  class CacheControl
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      [status, patch_response_headers(headers), body]
    end

  protected
    CACHE_CONTROL = {
      "Cache-Control" => "public, max-age=3600",
    }

    def patch_response_headers(env)
      env.merge(CACHE_CONTROL)
    end
  end
end
