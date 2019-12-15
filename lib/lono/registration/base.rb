class Lono::Registration
  class Base
    extend Memoist

    def initialize(options={})
      @options = options
    end

    # Same api call for temp_key and registration_key
    def request_verification(info)
      with_safety do
        api.verify(info)
      end
    end

    def get_temp_key
      with_safety do
        api.temp_key # grab temp registration key
      end
    end

    def with_safety
      yield
    rescue Errno::ECONNREFUSED, Errno::EAFNOSUPPORT
      raise if Lono::API != Lono::API_DEFAULT
    end

    def api
      Lono::Api::Client.new
    end
    memoize :api

    def say(msg)
      puts msg if @options[:cli]
    end
  end
end