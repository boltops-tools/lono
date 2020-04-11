module Lono
  class Registration < Command
    desc "check", "Check .lono/registration.yml file"
    long_desc Help.text(:check)
    option :debug, type: :boolean, desc: "Enable debug mode"
    def check
      User.new(options.merge(cli: true)).check
    end

    desc "temp_check", "Check .lono/temp.yml file", hide: true
    def temp_check
      Temp.new.check
    end

    def self.check
      Check.new.check
    end
  end
end
