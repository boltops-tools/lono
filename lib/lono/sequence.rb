require "byebug" if ENV['USER'] == 'tung'
require 'fileutils'
require 'colorize'
require 'active_support/core_ext/string'
require 'thor'
require 'bundler'

class Lono::Sequence < Thor::Group
  include Thor::Actions

  def self.template_name
    ENV['TEMPLATE'] || 'skeleton'
  end

  def self.source_root
    File.expand_path("../starter_projects/#{template_name}", File.dirname(__FILE__))
  end

private
  def git_installed?
    system("type git > /dev/null")
  end
end
