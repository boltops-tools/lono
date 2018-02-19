# File must be name in underscore casing and the module name must be named in
# CamelizeCasing.  The file must also end in _helper.rb by convention.
# More info http://lono.cloud/docs/helpers
# Custom Helpers are loaed into the same scope as built-in lono helpers and are
# treated a first class citizens.  They have access to all the same methods
# and instance variable as the built-in lono helpers.
module MyCustomHelper
  # This example helper method checks if the file path exists and fails gracefully
  # the built-in partial fails hard.
  def shared_partial(name, options={}, indent=0)
    partial_name = "shared/#{name}.yml.erb"
    if partial_exist?(partial_name) # partial_exist? is built-in lono helper
      result << partial(partial_name, {}, indent: indent)
      result.join("\n")
    end
  end
end
