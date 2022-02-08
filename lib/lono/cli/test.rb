class Lono::CLI
  class Test
    def initialize(options={})
      @options = options
    end

    def run
      config = Lono.config
      test_command = config.test.framework
      execute(test_command)
    end

    def execute(command)
      command = adjust_command(command)
      puts "=> #{command}"
      Kernel.exec(command)
    end

    def adjust_command(command)
      if cd_into_test?
        command = "bundle exec #{command}" unless command.include?("bundle exec")
        command = "cd test && #{command}"
      else
        command
      end
    end

    # Automatically cd into the test folder in case running within the root of a module.
    # Detect/guess that we're in a module folder vs the lono project
    def cd_into_test?
      !File.exist?("app") && File.exist?("test") &&
      (File.exist?("template.rb") || File.exist?("template"))
    end
  end
end
