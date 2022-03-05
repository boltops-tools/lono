class Lono::App::CallableOption
  module Concern
    def callable_option(options={})
      callable_option = Lono::App::CallableOption.new(
        config_name: options[:config_name],
        config_value: options[:config_value],
        passed_args: options[:passed_args],
      )
      callable_option.object
    end
  end
end
