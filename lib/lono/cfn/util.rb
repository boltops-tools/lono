module Lono::Cfn::Util
  def are_you_sure?(stack_name, action)
    if @options[:sure]
      sure = 'y'
    else
      message = case action
      when :update
        "Are you sure you want to want to update the '#{stack_name}' stack with the changes? (y/N)"
      when :delete
        "Are you sure you want to want to delete the '#{stack_name}' stack? (y/N)"
      end
      puts message
      sure = $stdin.gets
    end

    unless sure =~ /^y/
      puts "Whew! Exiting without running #{action}."
      exit 0
    end
  end
end
