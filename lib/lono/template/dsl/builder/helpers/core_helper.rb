module Lono::Template::Dsl::Builder::Helpers
  module CoreHelper
    extend Memoist

    def tags(list={})
      casing = list.delete(:casing) || :camelize
      if list.empty?
        tag_list(@tags) # when list is empty, we'll use variables
      else
        tag_list(list, casing: casing)
      end
    end

    def tag_list(list, casing: :camelize)
      raise "tags list cannot be empty" if list == nil

      if list.is_a?(Array)
        hash = list.inject({}) do |h,i|
          i.symbolize_keys!
          h[i[:Key]] = i[:Value]
          h
        end
        return tag_list(hash) # recursive call tag_list to normalized the argument with a Hash
      end

      list.map do |k,v|
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