class Lono::Builder::Dsl::Finalizer::Files
  class Replace < Base
    def run
      replacements.each do |placeholder, replacement|
        update_template!(@cfn)
      end
      @cfn
    end

    def replacements
      data = Lono::Files.files.inject({}) do |result, file|
        result.merge(file.marker => file.s3_key)
      end
      # Edge case when bucket is created for the first time and files_bucket is
      # not available yet. So we call it at this point.
      Lono::S3::Bucket.ensure_exist
      data["LONO://S3_BUCKET"] = Lono::S3::Bucket.name
      data
    end

    def update_template!(hash)
      hash.each do |k, v|
        if v.is_a?(String)
          if v =~ %r{^LONO://}
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
  end
end
