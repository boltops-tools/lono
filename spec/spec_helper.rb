ENV['LONO_TEST'] = '1'
# Ensures aws api never called. Fixture home folder does not contain ~/.aws/credentails
ENV['HOME'] = "#{Dir.pwd}/spec/fixtures/home"
# We'll always re-generate a new lono project in tmp. It can be:
#
#   1. copied from spec/fixtures/lono_project
#   2. generated from `lono new`
#
# This is done because changing LONO_ROOT for specs was a mess.
ENV['LONO_ROOT'] = "#{Dir.pwd}/tmp/lono_project" # this gets kept
ENV['AWS_REGION'] ||= "us-west-2"

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
    ENV['LONO_DEBUG'] || ENV['SHOW_COMMAND']
  end

  def ensure_tmp_exists
    FileUtils.mkdir_p("tmp")
  end

  # Copies spec/fixtures/lono_project to tmp/lono_project,
  # Main fixture we'll use because it's faster
  def copy_lono_project
    destroy_lono_project(true)
    FileUtils.cp_r("spec/fixtures/lono_project", "tmp/lono_project")
  end

  def destroy_lono_project(force=false)
    return if ENV['KEEP_TMP_PROJECT'] && !force
    # Only use KEEP_TMP_PROJECT if you are testing exactly 1 spec for debugging
    # or it'll affect other tests.
    FileUtils.rm_rf(Lono.root)
  end
end

RSpec.configure do |c|
  c.include Helper
  c.before(:all) do
    ensure_tmp_exists
    copy_lono_project
  end
  c.after(:all) do
    destroy_lono_project
  end
end

# Using this helper since the strings in the parsed structure are actually Parslet::Slice
# and have the .str method, which is used in the Transform class
# Hack only for specs.
class String
  def str
    to_s
  end
end
