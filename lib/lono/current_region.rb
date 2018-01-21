require 'aws-sdk-core'

module Lono::CurrentRegion
  def current_region
    region = Aws.config[:region]
    region ||= ENV['AWS_REGION']
    return region if region

    if ENV['AWS_PROFILE']
      path = "#{ENV['HOME']}/.aws/config"
      if File.exist?(path)
        lines = IO.readlines(path)
        capture_default, capture_current = false, false
        lines.each do | line|
          if line.include?('[default]')
            capture_default = true # next line
            next
          end
          if capture_default && line.match(/region = /)
            default_region = line.split(' = ').last.strip
            capture_default = false
          end

          md = line.match(/\[profile (.*)\]/)
          if md && md[1] == ENV['AWS_PROFILE']
            capture_current = true
            next
          end
          if capture_current && line.match(/region = /)
            region = line.split(' = ').last.strip
            capture_current = false
          end
        end
      end

      region ||= default_region
      return region if region
    end

    'us-east-1' # default
  end
end
