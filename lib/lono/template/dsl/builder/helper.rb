# Built-in helpers for the DSL form
class Lono::Template::Dsl::Builder
  module Helper
    def tags(hash, casing: :camelize)
      hash.map do |k,v|
        k = k.to_s
        k = case casing
        when :camelize
          CfnCamelizer.camelize(k)
        when :underscore
          k.underscore
        when :dasherize
          k.dasherize
        else # leave alone
          k
        end

        {key: k, value: v}
      end
    end

    def user_data(path)
      path = "#{Lono.config.user_data_path}/#{path}"
      render_path(path)
    end

    def render_path(path)
      RenderMePretty.result(path, context: self)
    end
  end
end
