class Lono::Builder::Allow
  class Env < Base
    # interface method
    def message
      messages = []
      messages << "This env is not allowed to be used: LONO_ENV=#{Lono.env}"
      messages << "Allow envs: #{allows.join(', ')}" if allows
      messages << "Deny envs: #{denys.join(', ')}" if denys
      messages.join("\n")
    end

    # interface method
    def check_value
      Lono.env
    end
  end
end
