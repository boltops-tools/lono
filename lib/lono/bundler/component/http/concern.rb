require 'net/http'
require 'open-uri'

module Lono::Bundler::Component::Http
  module Concern
    include LB::Util::Logging

    def http_request(url, auth_domain: nil)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      # Total time will be 40s = 20 x 2
      http.max_retries = 1 # Default is already 1, just  being explicit
      http.read_timeout = 20 # Sites that dont return in 20 seconds are considered down
      request = Net::HTTP::Get.new(uri)

      if auth_domain
        path = "#{ENV['HOME']}/.terraform.d/credentials.tfrc.json"
        if File.exist?(path)
          data = JSON.load(IO.read(path))
          token = data['credentials'][auth_domain]['token']
          request.add_field 'Authorization', "Bearer #{token}"
        else
          auth_error_exit!
        end
      end

      begin
         http.request(request) # response
      rescue Net::OpenTimeout => e # internal ELB but VPC is not configured for Lambda function
        http_request_error_message(e)
      rescue Exception => e
        # Net::ReadTimeout - too slow
        # Errno::ECONNREFUSED - completely down
        # SocketError - improper url "dsfjsl" instead of example.com
        http_request_error_message(e)
      end
    end

    def http_request_error_message(e)
      logger.info "ERROR: #{e.message}\n#{e.message}".color(:red)
      exit 1
    end
  end
end
