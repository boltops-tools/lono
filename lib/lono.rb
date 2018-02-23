require 'active_support/core_ext/string'
require 'colorize'
require 'fileutils'
require 'json'
require 'pp'
require 'render_me_pretty'
require 'yaml'

# vendor because need https://github.com/futurechimp/plissken/pull/6 to be merged
$:.unshift(File.expand_path("../../vendor/plissken/lib", __FILE__))
require "plissken"

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
  autoload :Script, 'lono/script'
  autoload :UserData, 'lono/user_data'

  extend Core
end
