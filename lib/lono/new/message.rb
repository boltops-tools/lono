module Lono::New::Message
  private
  def welcome_message
    <<-EOL
#{"="*64}
Congrats 🎉 You have successfully created a lono project.

Cd into your project and check things out:

  cd #{project_name}

#{template_specific_message}
To re-generate your templates without launching a stack, you can run:

  lono generate

The generated CloudFormation templates are in the output/templates folder.
The generated stack parameters are in the output/params folder.

More info: http://lono.cloud/
EOL
  end

  def template_specific_message
    starter_projects = File.expand_path("../../starter_projects", File.dirname(__FILE__))
    welcome_path = "#{starter_projects}/#{ENV['TEMPLATE']}/welcome.txt"
    puts "welcome_path #{welcome_path.inspect}"

    # default to the skeleton welcome message
    unless File.exist?(welcome_path)
      welcome_path = "#{starter_projects}/skeleton/welcome.txt"
    end
    IO.read(welcome_path)
  end
end
