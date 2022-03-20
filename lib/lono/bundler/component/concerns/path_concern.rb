module Lono::Bundler::Component::Concerns
  module PathConcern
    def setup_tmp
      FileUtils.mkdir_p(cache_root)
      FileUtils.mkdir_p(stage_root)
    end

    def tmp_root
      "/tmp/lono/bundler"
    end

    def cache_root
      "#{tmp_root}/cache"
    end

    def stage_root
      "#{tmp_root}/stage"
    end

    def cache_path(name)
      [cache_root, @component.source_type, name].compact.join('/')
    end

    def stage_path(name)
      [stage_root, @component.source_type, name].compact.join('/')
    end

    # Fetcher: Downloader/Local copies to a slightly different folder.
    # Also, Copy will use this and reference same method so it's consistent.
    def rel_dest_dir
      case @component.source_type
      when 'local'
        @component.name      # example-module
      when 's3'
        path = type_path # https://s3-us-west-2.amazonaws.com/demo-terraform-test/example-module.zip
        remove_ext(path) # demo-terraform-test/blueprints/example-module
      when 'gcs'
        path = type_path # https://www.googleapis.com/storage/v1/BUCKET_NAME/PATH/TO/module.zip
        path.sub!(%r{storage/v\d+/},'')
        remove_ext(path) # terraform-example-blueprints/blueprints/example-module
      when 'http'
        path = type_path # https://www.googleapis.com/storage/v1/BUCKET_NAME/PATH/TO/module.zip
        remove_ext(path) # terraform-example-blueprints/blueprints/example-module
      else # inferred git, registry, git::, ssh://, git::ssh://
        @component.repo_folder #  tongueroo/example-module
      end
    end

    def type_path
      source = @component.source
      url = source.sub("#{@component.source_type}::",'')
      uri = URI(url)
      uri.path.sub('/','')   # removing leading slash to bucket name is the first thing
         .sub(%r{//(.*)},'') # remove subfolder
    end

    def remove_ext(path)
      ext = File.extname(path)
      path.sub(ext,'')
    end

    def get_bucket_key(path)
      bucket, *rest = path.split('/')
      key = rest.join('/')
      [bucket, key]
    end
  end
end
