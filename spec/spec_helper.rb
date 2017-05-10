require "pp"
require "byebug"
require "bundler"

ENV['TEST'] = '1'

Bundler.require(:development)

$root = File.expand_path('../../', __FILE__)

require "#{$root}/lib/lono"

require 'coveralls'
Coveralls.wear!

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
