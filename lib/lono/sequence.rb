require 'fileutils'
require 'colorize'
require 'active_support/core_ext/string'
require 'thor'
require 'bundler'

class Lono::Sequence < Thor::Group
  include Thor::Actions

  def self.source_root
    File.expand_path("../../template", __FILE__)
  end

private
  def copy_project
    puts "Creating new project called #{project_name}."
    directory ".", project_name
  end

  def git_installed?
    system("type git > /dev/null")
  end
end
