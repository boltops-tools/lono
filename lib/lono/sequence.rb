require "byebug" if ENV['USER'] == 'tung'
require 'fileutils'
require 'colorize'
require 'active_support/core_ext/string'
require 'thor'
require 'bundler'

class Lono::Sequence < Thor::Group
  include Thor::Actions

  def self.template_name
    ENV['TEMPLATE'] || 'single_server'
  end

  def self.source_root
    File.expand_path("../starter_projects/#{template_name}", File.dirname(__FILE__))
  end

private
  def git_installed?
    system("type git > /dev/null")
  end

  def template_specific_message
    meth = "#{self.class.template_name}_template_message"
    # respond_to?(meth) doesnt work because methods are private to prevent
    # Thor::Group from automatically running them.
    if private_methods.include?(meth.to_sym)
      send meth
    else
      # generic message
      generic_template_message
    end
  end

  def generic_template_message
      <<-EOL
Add templates to your project.  When you are ready to launch a CloudFormation stack run:

  lono cfn create STACK_NAME

You can also get started quickly by importing other CloudFormration templates into lono.

  lono import URL --name your-stack-name
  lono inspect summary your-stack-name
EOL
  end

  def single_server_template_message
    path = File.expand_path("../starter_projects/single_server/config/params/base/example.txt", File.dirname(__FILE__))
    example_params_content = IO.readlines(path).map { |l| "  #{l}" }.join("")

    <<-EOL
The example template uses a keypair named default. Be sure that keypair exists.  Or you can adjust the KeyName parameter in config/params/base/example.txt. Here are contents of the file:

#{example_params_content}
To launch an example CloudFormation stack:

  lono cfn create example
EOL
  end
end
