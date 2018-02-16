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
    starter_projects = File.expand_path("../starter_projects", File.dirname(__FILE__))
    template_folder = "#{starter_projects}/#{template_name}"
    unless File.exist?(template_folder)
      templates = Dir.glob("#{starter_projects}/*")
        .select { |f| File.directory?(f) }
        .map { |f| "  #{File.basename(f)}" }
        .sort
      puts "The TEMPLATE=#{ENV['TEMPLATE']} you specified does not exist.".colorize(:red)
      puts "The available templates are:\n#{templates.join("\n")}"
      exit
    end
    template_folder
  end

private
  def git_installed?
    system("type git > /dev/null")
  end
end
