# Ensures aws api never called. Fixture home folder does not contain ~/.aws/credentials
ENV['HOME'] = "#{Dir.pwd}/spec/fixtures/home"
ENV['AWS_REGION'] ||= "us-west-2"
ENV['LONO_TEST'] = '1'
ENV['LONO_ROOT'] = "#{Dir.pwd}/spec/fixtures/project"

require "pp"
require "byebug"

root = File.expand_path("../", File.dirname(__FILE__))
require "#{root}/lib/lono"

Dir.glob("./spec/spec_helper/**/*.rb").each do |file|
  require file
end
module Helper
  include SpecHelper::Logging
  include SpecHelper::Execute
end

RSpec.configure do |c|
  c.include Helper
  c.before(:each) do
    override_logger
  end
  c.after(:each) do
    flush_overriden_logger
  end
end
