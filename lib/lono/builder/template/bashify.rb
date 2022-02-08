require 'open-uri'

class Lono::Builder::Template
  class Bashify
    include Lono::Utils::Logging

    def initialize(options={})
      @options = options
      @path = options[:path]
    end

    def user_data_paths(data,path="")
      paths = []
      paths << path
      data.each do |key,value|
        if value.is_a?(Hash)
          paths += user_data_paths(value,"#{path}/#{key}")
        else
          paths += ["#{path}/#{key}"]
        end
      end
      paths.select {|p| p =~ /UserData/ && p =~ /Fn::Join/ }
    end

    def run
      raw = open(@path).read
      json = JSON.load(raw)
      paths = user_data_paths(json)
      if paths.empty?
        logger.info "No UserData script found"
        return
      end
      paths.each do |path|
        logger.info "UserData script for #{path}:"
        key = path.sub('/','').split("/").map {|x| "['#{x}']"}.join('')
        user_data = eval("json#{key}")
        delimiter = user_data[0]
        script = user_data[1]
        logger.info script.join(delimiter)
      end
    end
  end
end
