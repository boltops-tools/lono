require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'cfn_camelizer'
require 'fileutils'
require 'json'
require 'memoist'
require 'plissken'
require 'rainbow/ext/string'
require 'render_me_pretty'
require 'yaml'

$:.unshift(File.expand_path('../', __FILE__))
module Lono
  autoload :Blueprint, 'lono/blueprint'
  autoload :Cfn, 'lono/cfn'
  autoload :Clean, 'lono/clean'
  autoload :CLI, 'lono/cli'
  autoload :Command, 'lono/command'
  autoload :Completer, 'lono/completer'
  autoload :Completion, 'lono/completion'
  autoload :Configure, 'lono/configure'
  autoload :Conventions, 'lono/conventions'
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

Lono.set_aws_profile!
