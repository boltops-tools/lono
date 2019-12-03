module Lono
  class Location
    extend Memoist

    def initialize(options, root=Lono.root, env=Lono.env)
      @stack = options[:stack]
      @blueprint = options[:blueprint]
      @template = options[:template]
      @param = options[:param]
      @root, @env = root, env
    end

    def lookup
      template_level = "#{@root}/configs/#{@blueprint}/params/#{@env}/#{@template}/#{@param}"
      env_level = "#{@root}/configs/#{@blueprint}/params/#{@env}/#{@param}"
      params_level = "#{@root}/configs/#{@blueprint}/params/#{@param}"
      generic_env = "#{@root}/configs/#{@blueprint}/params/#{@env}"

      found = [template_level, env_level, params_level, generic_env].find do |level|
        param_file(level)
      end
      param_file(found) if found
    end

    def param_file(path)
      # List of paths to consider from initial path provided
      paths = [path, "#{path}.txt", "#{path}.sh"]
      paths.find { |p| File.file?(p) }
    end
    memoize :param_file
  end
end
