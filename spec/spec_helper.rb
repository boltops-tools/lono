ENV['TEST'] = '1'
# Ensures aws api never called. Fixture home folder does not contain ~/.aws/credentails
ENV['HOME'] = "spec/fixtures/home"
ENV['LONO_ROOT'] = "spec/fixtures/lono_project" # this gets kept
ENV['TMP_LONO_ROOT'] = "./tmp/lono_project" # need the period for the load_custom_helpers require , unsure if I should adjust the LOAD_PATH

require "pp"
require "byebug"

# require "bundler"
# Bundler.require(:development)

root = File.expand_path("../", File.dirname(__FILE__))
require "#{root}/lib/lono"

module Helper
  def execute(cmd)
    puts "Running: #{cmd}" if show_command?
    out = `#{cmd}`
    puts out if show_command?
    out
  end

  # Added SHOW_COMMAND because DEBUG is also used by other libraries like
  # bundler and it shows its internal debugging logging also.
  def show_command?
    ENV['DEBUG'] || ENV['SHOW_COMMAND']
  end
end

RSpec.configure do |c|
  c.include Helper
end
