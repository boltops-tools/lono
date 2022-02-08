class Lono::Builder::Template
  class PostProcessor < Lono::CLI::Base
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
        if item.type == "lambda_layer"
          placeholder = "file://app/files/lambda_layer/#{item.name}"
        elsif item.directory? || item.file?
          placeholder = "file://app/files/file/#{item.name}"
        else
          logger.info "WARN: PostProcessor replacements Cannot find file: #{item.output_path}"
          next
        end
        map[placeholder] = item.s3_path
      end

      Lono::Configset::S3File::Registry.items.each do |item|
        placeholder = "file://configset/#{item.configset}/#{item.name}"
        # map[placeholder] = "https://s3.amazonaws.com/#{Lono::S3::Bucket.name}/#{item.s3_path}"
        map[placeholder] = item.replacement_value
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
      "#{Lono.root}/output/#{@blueprint.name}/templates/#{@template}.yml"
    end
  end
end