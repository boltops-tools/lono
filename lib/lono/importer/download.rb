require "json"
require "open-uri"
require "yaml"

class Lono::Importer
  module Download
    def download_template(source, dest_path)
      template =  read_source(source)

      result = if json?(template)
                  # abusing YAML.dump(YAML.load()) to convert json to yaml
                  YAML.dump(YAML.load(template))
                else
                  template # template is already in YAML format
                end

      folder = File.dirname(dest_path)
      FileUtils.mkdir_p(folder) unless File.exist?(folder)
      IO.write(dest_path, result)
      dest_path
    end

    def read_source(source)
      open(source).read
    rescue OpenURI::HTTPError, SocketError, Errno::ENOENT
      puts "ERROR: Unable to read source template provided: #{source}".color(:red)
      e = $!
      puts "#{e.class}: #{e.message}"
      puts "Please double check the source provided."
      exit 1
    rescue Exception => e
      puts "ERROR: Unable to read source template provided: #{source}".color(:red)
      puts "General Exception Error:"
      puts "#{e.class}: #{e.message}"
      puts "Please double check the source provided."
      exit 1
    end

    def json?(text)
      JSON.load(text)
      true # if reach here than it's just
    rescue JSON::ParserError
      false # not json
    end
  end
end