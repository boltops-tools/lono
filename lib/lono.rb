require 'json'
require 'yaml'
require 'pp'
require 'colorize'
require 'fileutils'
# http://guides.rubyonrails.org/active_support_core_extensions.html#inflections
require 'active_support/core_ext/string'

# vendor because need https://github.com/futurechimp/plissken/pull/6 to be merged
$:.unshift(File.expand_path("../../vendor/plissken/lib", __FILE__))
require "plissken"

# vendor because pretty new gem and need to test it more
$:.unshift(File.expand_path("../../vendor/render_me_pretty/lib", __FILE__))
require "render_me_pretty"
require "tilt" # render_me_pretty dependency

$:.unshift(File.expand_path('../', __FILE__))
module Lono
  autoload :VERSION, 'lono/version'
  autoload :Env, 'lono/env'
  autoload :Help, 'lono/help'
  autoload :ProjectChecker, 'lono/project_checker'
  autoload :Command, 'lono/command'
  autoload :CLI, 'lono/cli'
  autoload :New, 'lono/new'
  autoload :Sequence, 'lono/sequence'
  autoload :Template, 'lono/template'
  autoload :Cfn, 'lono/cfn'
  autoload :Param, 'lono/param'
  autoload :Clean, 'lono/clean'
  autoload :Setting, 'lono/setting'
  autoload :Importer, 'lono/importer'
  autoload :Inspector, 'lono/inspector'
  autoload :Completion, 'lono/completion'
  autoload :Completer, 'lono/completer'
  autoload :Core, 'lono/core'
  autoload :Upgrade4, 'lono/upgrade4'

  extend Core
end
