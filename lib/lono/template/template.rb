require 'erb'
require 'json'
require 'base64'

class Lono::Template::Template
  include Lono::CurrentRegion
  include ERB::Util

  def initialize(name, block=nil, options={})
    # Taking care to name instance variables with _ in front because we load the
    # variables from config/variables and those instance variables can clobber these
    # instance variables
    @name = name
    @block = block
    @options = options
    @source = default_source(name)
  end

  # Main template DSL methods.
  #
  #   template "example-2" do
  #     source "example"
  #     variables(test: 1)
  #   end
  def source(path)
    @source = path[0..0] == '/' ? path : "#{Lono.config.templates_path}/#{path}"
    @source += ".yml"
  end

  def variables(vars={})
    vars.each do |var,value|
      instance_variable_set("@#{var}", value)
    end
  end

  # internal methods
  def default_source(name)
    "#{Lono.config.templates_path}/#{name}.yml" # defaults to name, source method overrides
  end

  def build
    instance_eval(&@block) if @block

    # template = Tilt::ERBTemplate.new(@source)
    # template.render(context)
    RenderMePretty.result(@source, context: context)
  end

  # Context for ERB rendering.
  # This is where we control what references get passed to the ERB rendering.
  def context
    @context ||= Lono::Template::Context.new(@options)
  end
end
