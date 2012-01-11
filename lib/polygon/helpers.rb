module Polygon
  module Helpers

    def static;    settings.static;    end
    def dynamic;   settings.dynamic;   end
    def templates; settings.templates; end

    def default_wlang_context
      { "environment" => settings.environment }
    end

    def wlang(tpl, ctx = {})
      tpl = templates/"#{tpl}.whtml" if tpl.is_a?(Symbol)
      ctx = (ctx && ctx.to_hash) || {}
      ctx = default_wlang_context.to_hash.merge(ctx)
      WLang::file_instantiate tpl, ctx
    end

  end # module Helpers
end # module Polygon
