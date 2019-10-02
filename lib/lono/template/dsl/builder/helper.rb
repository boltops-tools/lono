# Built-in helpers for the DSL form
class Lono::Template::Dsl::Builder
  module Helper
    extend Memoist

    def tags(hash, casing: :camelize)
      hash.map do |k,v|
        k = k.to_s
        k = case casing
        when :camelize
          CfnCamelizer.camelize(k)
        when :underscore
          k.underscore
        when :dasherize
          k.dasherize
        else # leave alone
          k
        end

        {key: k, value: v}
      end
    end

    def dimensions(hash, casing: :camelize)
      tags(hash, casing: casing).map { |h|
        h[:name] = h.delete(:key)
        h
      }
    end

    def user_data(path)
      path = "#{Lono.config.user_data_path}/#{path}"
      if File.exist?(path)
        render_path(path)
      else
        message = "WARNING: user-data path #{path} not found"
        puts message.color(:yellow)
        puts "Called from:"
        puts caller[1]
        message
      end
    end
    memoize :user_data

    def render_path(path)
      RenderMePretty.result(path, context: self)
    end

    def s3_bucket
      Lono::S3::Bucket.name
    end

    def file_s3_key(name, options={})
      Lono::AppFile::Registry.register(name, @blueprint, options)
      "file://app/files/#{name}" # placeholder for post processing
    end
    alias_method :s3_key, :file_s3_key

    def setting
      Lono::Setting.new
    end
    memoize :setting
  end
end
