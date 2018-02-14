require 'erb'
require 'json'
require 'base64'

class Lono::Template::Template
  include Lono::Template::Helpers
  include Lono::CurrentRegion
  include ERB::Util

  def initialize(name, block=nil, options={})
    # Taking care to name instance variables with _ in front because we load the
    # variables from config/variables and those instance variables can clobber these
    # instance variables
    @_name = name
    @_options = options
    @_block = block
    @_config_path = "#{Lono.root}/config"
    @_source = default_source(name)
  end

  def default_source(name)
    "#{Lono.config.templates_path}/#{name}.yml" # defaults to name, source method overrides
  end

  def build
    load_variables
    load_custom_helpers
    instance_eval(&@_block) if @_block
    template = IO.read(@_source)
    erb_result(@_source, template)
  end

  def load_variables
    load_variables_folder("base")
    load_variables_folder(Lono.env)
  end

  # Load the variables defined in config/variables/* to make available in the
  # template blocks in config/templates/*.
  #
  # Example:
  #
  #   `config/variables/base/variables.rb`:
  #     @foo = 123
  #
  #   `config/templates/base/resources.rb`:
  #      template "mytemplate.yml" do
  #        source "mytemplate.yml.erb"
  #        variables(foo: @foo)
  #      end
  #
  # NOTE: Only able to make instance variables avaialble with instance_eval
  #   Wasnt able to make local variables available.
  def load_variables_folder(folder)
    paths = Dir.glob("#{@_config_path}/variables/#{folder}/**/*")
    paths.select{ |e| File.file? e }.each do |path|
      instance_eval(IO.read(path))
    end
  end

  # Load custom helper methods from project
  def load_custom_helpers
    Dir.glob("#{Lono.config.helpers_path}/**/*_helper.rb").each do |path|
      filename = path.sub(%r{.*/},'').sub('.rb','')
      module_name = filename.classify

      # Prepend a period so require works LONO_ROOT is set to a relative path
      # without a period.
      #
      # Example: LONO_ROOT=tmp/lono_project
      first_char = path[0..0]
      path = "./#{path}" unless %w[. /].include?(first_char)
      require path
      self.class.send :include, module_name.constantize
    end
  end

  def source(path)
    @_source = path[0..0] == '/' ? path : "#{Lono.config.templates_path}/#{path}"
    @_source += ".yml"
  end

  def variables(vars={})
    vars.each do |var,value|
      instance_variable_set("@#{var}", value)
    end
  end

  def erb_result(path, template)
    begin
      ERB.new(template, nil, "-").result(binding)
    rescue Exception => e
      puts e
      puts e.backtrace if ENV['DEBUG']

      # how to know where ERB stopped? - https://www.ruby-forum.com/topic/182051
      # syntax errors have the (erb):xxx info in e.message
      # undefined variables have (erb):xxx info in e.backtrac
      error_info = e.message.split("\n").grep(/\(erb\)/)[0]
      error_info ||= e.backtrace.grep(/\(erb\)/)[0]
      raise unless error_info # unable to find the (erb):xxx: error line
      line = error_info.split(':')[1].to_i
      puts "Error evaluating ERB template on line #{line.to_s.colorize(:red)} of: #{path.sub(/^\.\//, '').colorize(:green)}"

      template_lines = template.split("\n")
      context = 5 # lines of context
      top, bottom = [line-context-1, 0].max, line+context-1
      spacing = template_lines.size.to_s.size
      template_lines[top..bottom].each_with_index do |line_content, index|
        line_number = top+index+1
        if line_number == line
          printf("%#{spacing}d %s\n".colorize(:red), line_number, line_content)
        else
          printf("%#{spacing}d %s\n", line_number, line_content)
        end
      end
      exit 1 unless ENV['TEST']
    end
  end

  # For simple just parameters files that can also be generated with lono, the CFN
  # Fn::Base64 function is not available and as lono is not being used in the context
  # of CloudFormation.  So this can be used in it's place.
  def encode_base64(text)
    Base64.strict_encode64(text).strip
  end

  def name
    @_name
  end
end
