module Lono
  module Conventions
    # Think can make this a module, but need to figure out how it fits with lono cfn
    def template_param_convention(options)
      options = options.deep_symbolize_keys
      template = options[:template] || @blueprint
      param = options[:param] || template || @blueprint
      [template, param]
    end
  end
end
