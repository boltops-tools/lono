require 'aws-sdk-s3'
require 'uri'

class Lono::Bundler::Component::Fetcher
  class S3 < Base
    extend Memoist

    def run
      region, bucket, key, path = s3_info
      download(region, bucket, key, path)
    end

    def download(region, bucket, key, path)
      # Download to cache area
      response_target = cache_path(path) # temporary path

      unless File.exist?(response_target)
        logger.debug "S3 save archive to #{response_target}".color(:yellow)
        FileUtils.mkdir_p(File.dirname(response_target))
        s3_get(region, response_target, bucket, key)
      end

      # Save to stage
      dest = stage_path(rel_dest_dir)
      extract(response_target, dest)
    end

  private
    def s3_get(region, response_target, bucket, key)
      s3(region).get_object(
        response_target: response_target,
        bucket: bucket,
        key: key,
      )
    rescue Aws::S3::Errors::NoSuchBucket, Aws::S3::Errors::NoSuchKey => e
      logger.error(<<~EOL.color(:red))
        ERROR: #{e.class} #{e.message}

            bucket: #{bucket}
            key: #{key}

      EOL
      exit 1
    end

    def s3_info
      path = type_path
      bucket, key = get_bucket_key(path)

      url = @component.source.sub('s3::','')
      uri = URI(url)
      region = if uri.host == 'https://s3.amazonaws.com'
                 'us-east-1'
               else
                 uri.host.match(/s3-(.*)\.amazonaws/)[1]
               end

      [region, bucket, key, path]
    end

    def s3(region)
      Aws::S3::Client.new(region: region)
    end
    memoize :s3
  end
end
