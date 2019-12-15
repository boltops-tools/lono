class Lono::Template
  class PostProcessor < Lono::AbstractBase
    def run
      replacements.each do |placeholder, replacement|
        update_template!(template)
      end
      write_template!
    end

    def write_template!
      IO.write(template_path, YAML.dump(template)) # unless ENV['LONO_TEST'] # additional safeguard for testing
    end

    def replacements
      map = {}
      registry_items.each do |item|
        if item.directory? || item.file?
          replacement = item.s3_path
        else
          puts "WARN: PostProcessor replacements Cannot find file: #{item.path}"
          next
        end

        placeholder = "file://app/files/#{item.name}"
        map[placeholder] = replacement
      end
      map
    end

    def update_template!(hash)
      hash.each do |k, v|
        if v.is_a?(String)
          if v =~ %r{^file://}
            v.replace(replacements[v]) # replace the placeholder
          end
        elsif v.is_a?(Hash)
          update_template!(v) # recurse
        elsif v.is_a?(Array)
          v.each { |x| update_template!(x) if x.is_a?(Hash) }
        end
      end
      hash
    end

    # Useful for specs
    def registry_items
      Lono::AppFile::Registry.items
    end

    def template
      YAML.load_file(template_path)
    end
    memoize :template

    def template_path
      "#{Lono.config.output_path}/#{@blueprint}/templates/#{@template}.yml"
    end
  end
end