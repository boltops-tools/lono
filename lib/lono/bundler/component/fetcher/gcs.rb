begin
  require "google/cloud/storage"
rescue LoadError => e
  $stderr.puts "#{e.class}: #{e.message}".color(:red)
  $stderr.puts <<~EOL

    Unable to: require "google/cloud/storage"

    In order to use gcs as a lono bundler source,
    please add the google-cloud-storage gem to
    your Lono project's Gemfile and run bundle.

    To add the gem to your Gemfile, you can run:

        bundle add google-cloud-storage

    Then download blueprints in defined your Lonofile with:

        lono bundle
  EOL
  exit 1
end

class Lono::Bundler::Component::Fetcher
  class Gcs < Base
    extend Memoist

    def run
      bucket, key, path = gcs_info
      download(bucket, key, path)
    end

    def download(bucket_name, key, path)
      # Download to cache area
      bucket = storage.bucket(bucket_name)
      unless bucket
        logger.error "ERROR: bucket #{bucket_name} does not exist".color(:red)
        exit 1
      end
      file = bucket.file(key)
      unless file
        logger.error "ERROR: Unable to find gs://#{bucket_name}/#{key}".color(:red)
        exit 1
      end

      archive = cache_path(path) # temporary path
      logger.debug "Gcs save archive to #{archive}"
      FileUtils.mkdir_p(File.dirname(archive))
      file.download(archive)

      # Save to stage
      dest = stage_path(rel_dest_dir)
      extract(archive, dest)
    end

  private
    def gcs_info
      path = type_path
      path.sub!(%r{storage/v\d+/},'')
      bucket, key = get_bucket_key(path)
      [bucket, key, path]
    end

    def storage
      Google::Cloud::Storage.new
    end
    memoize :storage
  end
end
