require 'active_support/core_ext/string'
require 'fileutils'
require 'json'
require 'memoist'
require 'pp'
require 'rainbow'
require 'render_me_pretty'
require 'yaml'

# vendor because need https://github.com/futurechimp/plissken/pull/6 to be merged
$:.unshift(File.expand_path("../../vendor/plissken/lib", __FILE__))
require "plissken"

$:.unshift(File.expand_path('../', __FILE__))
module Lono
  autoload :Cfn, 'lono/cfn'
  autoload :Clean, 'lono/clean'
  autoload :CLI, 'lono/cli'
  autoload :Command, 'lono/command'
  autoload :Completer, 'lono/completer'
  autoload :Completion, 'lono/completion'
  autoload :Core, 'lono/core'
  autoload :Env, 'lono/env'
  autoload :FileUploader, 'lono/file_uploader'
  autoload :Help, 'lono/help'
  autoload :Importer, 'lono/importer'
  autoload :Inspector, 'lono/inspector'
  autoload :New, 'lono/new'
  autoload :Param, 'lono/param'
  autoload :ProjectChecker, 'lono/project_checker'
  autoload :Script, 'lono/script'
  autoload :Sequence, 'lono/sequence'
  autoload :Setting, 'lono/setting'
  autoload :Template, 'lono/template'
  autoload :Upgrade, 'lono/upgrade'
  autoload :UserData, 'lono/user_data'
  autoload :VERSION, 'lono/version'

  extend Core
end
