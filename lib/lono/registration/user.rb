class Lono::Registration
  class User < Base
    include Lono::Template::Context::Helpers # for ssm helper

    def check
      info = read_registration
      unless info
        say "Lono is not registered."
        say "The .lono/registration.yml and ~/.lono/registration.yml file does not exist."
        return false
      end
      unless info[:content].is_a?(Hash)
        say "Lono is not registered."
        say "#{info[:path]} does not have the right structure"
        return false
      end

      @resp = request_verification(info[:content])
      # A non-200 response means there was a non-200 http response. Failsafe behavior is to continue.
      # Unless called from the cli: lono registration check
      if @resp.nil?
        if @options[:cli]
          puts "There was an error with the API. Unable to confirm lono registration."
          return false
        else
          return true
        end
      end

      if @resp[:valid]
        say "Lono registration looks good!"
        return true
      end

      if @resp[:message]
        say "Lono is not correctly registered. Unable to confirm info in #{info[:path]}"
        say @resp[:message]
      end
      false
    end

    def read_registration
      folders = [Lono.root, ENV['HOME']]
      files = folders.map { |f| "#{f}/.lono/registration.yml" }
      found = files.find do |path|
        File.exist?(path)
      end
      return unless found

      content = RenderMePretty.result(found, context: self)
      if @options[:debug]
        puts "Debug mode enabled. Here's the lono registration info being used:"
        puts "Using: #{found}"
        puts content
        puts
      end
      {path: found, content: YAML.load(content)}
    end
  end
end
