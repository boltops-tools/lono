# Incentive to register. Not meant for security.
class Lono::Registration
  class Temp < Base
    def check
      info = read_registration
      if info
        resp = request_verification(info)
        puts "request_verification resp #{resp.inspect}" if ENV['LONO_DEBUG_REGISTRATION']
        # resp nil means non-200 http response. Failsafe behavior is to continue.
        return true if resp.nil?
      end

      prompt unless resp && resp[:valid]
      true
    end

    def read_registration
      YAML.load_file(temp_path) if File.exist?(temp_path)
    end

    def prompt
      return if ENV['LONO_TEST']

      # We get the api first before the prompt to check if api is up
      resp = get_temp_key
      # resp nil means non-200 http response. Failsafe behavior is to continue.
      if resp.nil?
        return true
      end

      puts <<~EOL
        Lono is not registered. This prompt appears every 24 hours when lono is not registered.
        To remove this prompt, please set up your registration info in .lono/registration.yml.

        Registration is free. You can register at:

            https://register.lono.cloud

        More info: https://lono.cloud/docs/register/

        Continue temporarily without registration? (y/N)
      EOL

      answer = $stdin.gets.to_s.strip # nil on CI
      if answer !~ /^y/i
        puts "Exiting."
        exit 1
      end

      save_temp_key(resp) # save key if user confirms
    end

    def save_temp_key(info)
      FileUtils.mkdir_p(File.dirname(temp_path))
      IO.write(temp_path, YAML.dump(info.deep_stringify_keys))
    end

    def temp_path
      "#{ENV['HOME']}/.lono/temp.yml"
    end
  end
end
