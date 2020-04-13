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

      puts <<~EOL

        Looks like lono is not registered. Lono registration is optional and free.
        If you like lono though, please register to help support it. You can register at:

            https://register.lono.cloud

        This prompt appears every 24 hours when lono is not registered. Registration removes
        this message. Registered users can also optionally receive updates and special offers,
        including discounts to BoltOps Pro:

            https://lono.cloud/docs/boltops-pro/

      EOL

      # resp nil means non-200 http response
      resp = get_temp_key
      save_temp_key(resp) unless resp.nil? # save temp key so prompt only happens periodically
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
