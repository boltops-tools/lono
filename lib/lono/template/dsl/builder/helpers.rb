# Built-in helpers for the DSL form
class Lono::Template::Dsl::Builder
  module Helpers
    extend Memoist
    include ParamHelper

    def tags(hash, casing: :camelize)
      hash.map do |k,v|
        k = k.to_s
        k = case casing
        when :camelize
          k.camelize
        when :underscore
          k.underscore
        when :dasherize
          k.dasherize
        else # leave alone
          k
        end

        {Key: k, Value: v}
      end
    end

    def dimensions(hash, casing: :camelize)
      tags(hash, casing: casing).map { |h|
        h[:Name] = h.delete(:Key) || h.delete(:key)
        h
      }
    end

    def content(path)
      render_file(Lono.config.content_path, path)
    end

    def user_data(path)
      render_file(Lono.config.user_data_path, path)
    end

    def render_file(folder, path)
      path = "#{folder}/#{path}"
      if File.exist?(path)
        render_path(path)
      else
        message = "WARNING: path #{path} not found"
        puts message.color(:yellow)
        puts "Called from:"
        puts caller[2]
        message
      end
    end
    memoize :render_file

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