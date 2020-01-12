$stdout.sync = true unless ENV["LONO_STDOUT_SYNC"] == "0"

require "active_support/core_ext/class"
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'fileutils'
require 'json'
require 'memoist'
require 'plissken'
require 'rainbow/ext/string'
require 'render_me_pretty'
require 'yaml'
require 'cfn_camelizer'

gem_root = File.dirname(__dir__)
$:.unshift("#{gem_root}/lib")
$:.unshift("#{gem_root}/vendor/cfn-status/lib")
require "cfn_status"

require "lono/ext/bundler"

require "lono/autoloader"
Lono::Autoloader.setup

module Lono
  API_DEFAULT = 'https://api.lono.cloud/v1'
  API = ENV['LONO_API'] || API_DEFAULT

  extend Core
end

Lono.set_aws_profile!
Lono.lono_pro_removal_check!
