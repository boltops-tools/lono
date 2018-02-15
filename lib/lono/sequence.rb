require 'fileutils'
require 'colorize'
require 'active_support/core_ext/string'
require 'thor'
require 'bundler'

class Lono::Sequence < Thor::Group
  include Thor::Actions

  def self.source_root
    File.expand_path("../starter_project", File.dirname(__FILE__))
  end

private
  def git_installed?
    system("type git > /dev/null")
  end
end
