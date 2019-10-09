$stdout.sync = true unless ENV["LONO_STDOUT_SYNC"] == "0"

require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'fileutils'
require 'json'
require 'memoist'
require 'plissken'
require 'rainbow/ext/string'
require 'render_me_pretty'
require 'yaml'

gem_root = File.dirname(__dir__)
$:.unshift("#{gem_root}/lib")
$:.unshift("#{gem_root}/vendor/cfn-status/lib")
require "cfn/status"

require "lono/autoloader"
Lono::Autoloader.setup

module Lono
  extend Core
end

Lono.set_aws_profile!

begin
  require "lono-pro" # optional
rescue LoadError
end