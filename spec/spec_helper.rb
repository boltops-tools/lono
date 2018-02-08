ENV['TEST'] = '1'
# Ensures aws api never called. Fixture home folder does not contain ~/.aws/credentails
ENV['HOME'] = "spec/fixtures/home"
ENV['LONO_ROOT'] = "spec/fixtures/my_project" # this gets kept
ENV['TMP_LONO_ROOT'] = "./tmp/lono_project" # need the period for the load_custom_helpers require , unsure if I should adjust the LOAD_PATH

require "pp"
require "byebug"
require "bundler"

Bundler.require(:development)

$root = File.expand_path('../../', __FILE__)

require "#{$root}/lib/lono"

# require 'coveralls'
# Coveralls.wear!

module Helpers
  def execute(cmd)
    puts "Running: #{cmd}" if ENV['DEBUG']
    out = `#{cmd}`
    puts out if ENV['DEBUG']
    out
  end
end

RSpec.configure do |c|
  c.include Helpers
end
