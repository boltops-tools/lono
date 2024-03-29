$stdout.sync = true unless ENV["LONO_STDOUT_SYNC"] == "0"

require 'active_support'
require 'active_support/core_ext/class'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'aws_data'
require 'cfn_camelizer'
require 'cfn_status'
require 'cli-format'
require 'dsl_evaluator'
require 'fileutils'
require 'json'
require 'lono/ext'
require 'memoist'
require 'plissken'
require 'rainbow/ext/string'
require 'render_me_pretty'
require 'singleton'
require 'yaml'

require "lono/autoloader"
Lono::Autoloader.setup

module Lono
  API_DEFAULT = 'https://api.lono.cloud/v1'
  API = ENV['LONO_API'] || API_DEFAULT
  extend Core
end

DslEvaluator.configure do |config|
  config.backtrace.select_pattern = Lono.root.to_s
  config.logger = Lono.logger
  config.on_exception = :exit
  config.root = Lono.root
end

Lono::Booter.boot
