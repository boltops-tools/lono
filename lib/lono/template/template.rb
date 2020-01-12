require 'erb'
require 'json'
require 'base64'

class Lono::Template::Template
  include ERB::Util

  # Main template Erb methods are: source and variables
  #
  #   template "example-2" do
  #     source "example"
  #     variables(test: 1)
  #   end
  #
  attr_reader :name
  def initialize(blueprint, name, block=nil, options={})
    @blueprint, @name, @block, @options = blueprint, name, block, options
    @source_path = default_source_path(name)
  end

  # Returns path, example: ./app/templates/example.yml
  def source(path)
    @source_path = path[0..0] == '/' ? path : "#{Lono.config.templates_path}/#{path}"
    @source_path += ".yml"
  end

  def variables(vars={})
    vars.each do |var,value|
      context.instance_variable_set("@#{var}", value)
    end
  end

  # internal methods
  def default_source_path(name)
    "#{Lono.config.templates_path}/#{name}.yml" # defaults to name, source method overrides
  end

  def build
    instance_eval(&@block) if @block

    if File.exist?(@source_path)
      RenderMePretty.result(@source_path, context: context)
    else
      puts "ERROR: #{@source_path} does not exist, but it was used as a template source.".color(:red)
      exit 1
    end
  end

  # Context for ERB rendering.
  # This is where we control what references get passed to the ERB rendering.
  def context
    @context ||= Lono::Template::Context.new(@options)
  end
end
