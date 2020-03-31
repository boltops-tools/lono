require 'fileutils'
require 'active_support/core_ext/string'
require 'thor'
require 'bundler'

class Lono::Sequence < Thor::Group
  include Thor::Actions

  def self.source_root
    File.expand_path("../templates/skeleton", File.dirname(__FILE__))
  end

private
  def git_installed?
    system("type git > /dev/null 2>&1")
  end

  def run_git?
    options[:git] && git_installed?
  end

  def run_git_init
    return unless run_git?
    puts "=> Initialize git repo"
    run("git init")
  end

  def run_git_commit
    return unless run_git?

    puts "=> Commit git repo"
    run("git add .")
    run("git commit -m 'first commit'")
  end
end
