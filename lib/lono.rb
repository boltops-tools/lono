require 'json'
require 'yaml'
require 'pp'
require 'colorize'
require 'fileutils'

# vendor because need https://github.com/futurechimp/plissken/pull/6 to be merged
$:.unshift(File.expand_path("../../vendor/plissken/lib", __FILE__))
require "plissken"

$:.unshift(File.expand_path('../', __FILE__))
module Lono
  autoload :VERSION, 'lono/version'
  autoload :Help, 'lono/help'
  autoload :ProjectChecker, 'lono/project_checker'
  autoload :Command, 'lono/command'
  autoload :CLI, 'lono/cli'
  autoload :New, 'lono/new'
  autoload :Template, 'lono/template'
  autoload :Cfn, 'lono/cfn'
  autoload :Param, 'lono/param'
  autoload :Clean, 'lono/clean'
end
