# Based on jets
class Lono::Files::Builder::LambdaLayer
  class RubyPackager < Lono::Files::Base
    include Rsync

    def build
      return unless gemfile_exist?
      pretty_path = pretty_path("#{@blueprint.root}/#{@files.path}")
      logger.debug "Packaging Lambda Layer #{pretty_path}"
      check_ruby_version!
      bundle_install
      package
    end

    def check_ruby_version!
      RubyVersion.new(@options).check!
    end

    # We consolidate all gems to opt
    def package
      setup_bundle_config(compiled_area)
      consolidate_gems_to_opt
    end

    # Installs gems on the current target system: both compiled and non-compiled.
    # If user is on a macosx machine, macosx gems will be installed.
    # If user is on a linux machine, linux gems will be installed.
    #
    # Copies Gemfile* to /tmp/jets/demo/cache folder and installs
    # gems with bundle install from there.
    #
    # We take the time to copy Gemfile and bundle into a separate directory
    # because it gets left around to act as a 'cache'.  So, when the builds the
    # project gets built again not all the gems from get installed from the
    # beginning.
    def bundle_install
      logger.debug "Bundling #{cache_area}"

      rsync(compiled_area, cache_area)

      # Uncomment out to always remove the cache/vendor/gems to debug
      # FileUtils.rm_rf("#{cache_area}/vendor/gems")

      # Remove .bundle folder so .bundle/config doesnt affect how gems are packages
      # Not using BUNDLE_IGNORE_CONFIG=1 to allow home ~/.bundle/config to affect bundling though.
      # This is useful if you have private gems sources that require authentication. Example:
      #
      #    bundle config gems.myprivatesource.com user:pass
      #

      FileUtils.rm_rf("#{cache_area}/.bundle")
      require "bundler" # dynamically require bundler so user can use any bundler
      setup_bundle_config(cache_area)
      Bundler.with_unbundled_env do
        sh "cd #{cache_area} && env bundle install"
      end

      remove_bundled_with("#{cache_area}/Gemfile.lock")
      # Fixes really tricky bug where Gemfile and Gemfile.lock is out-of-sync. Details: https://gist.github.com/tongueroo/b5b0d0c924a4a1633eee514795e4b04b
      FileUtils.cp("#{cache_area}/Gemfile.lock", compiled_area)

      logger.debug 'Bundle install success.'
    end

    def setup_bundle_config(dir)
      text =<<~EOL
        ---
        BUNDLE_PATH: "vendor/gems"
        BUNDLE_WITHOUT: "development:test"
      EOL
      bundle_config = "#{dir}/.bundle/config"
      FileUtils.mkdir_p(File.dirname(bundle_config))
      IO.write(bundle_config, text)
    end

    # Examples:
    #
    #   output/BLUEPRINT/lambda_layers/PATH/opt
    #   output/demo/lambda_layers/files/lambda-function/opt
    #   output/demo/lambda_layers/files/lambda-function # drop /opt to get dirname
    #
    # The build_parent is the parent folder because it can include cache and opt. Example tree:
    #
    #     output
    #     └── demo
    #         └── lambda_layers
    #             └── files
    #                 └── lambda-function  # <= build_area
    #                     ├── cache
    #                     └── opt
    #
    def build_area
      File.dirname(@files.output_path)
    end

    def cache_area
      "#{build_area}/cache"
    end

    # Final artifact that will be zipped up
    def opt_area
      "#{build_area}/opt"
    end

    # Original source is compiled to output folder
    #
    #     app/blueprints/demo/files/lambda-function/ - original
    #     output/demo/files/lambda-function/         - compiled
    #
    # Compiling is done beforehand to support .tt ERB in the files.
    #
    # Then it's moved again to a cache area to run `bundle`
    # Then it's moved yet agaoin to an opt area to produce the final Lambda Layer artifact.
    #
    def compiled_area
      @files.compiled_path
    end

    # Also restructure the folder from:
    #   vendor/gems/ruby/3.0.0
    # To:
    #   ruby/gems/3.0.0
    #
    # For Lambda Layer structure
    def consolidate_gems_to_opt
      src = "#{cache_area}/vendor/gems/ruby/#{ruby_folder}"
      dest = "#{opt_area}/ruby/gems/#{ruby_folder}"
      rsync_and_link(src, dest)
    end

    def rsync_and_link(src, dest)
      FileUtils.mkdir_p(dest)
      rsync(src, dest)

      # create symlink in output path not the cache path
      symlink_dest = "#{compiled_area}/vendor/gems/ruby/#{ruby_folder}"
      logger.debug "symlink_dest #{symlink_dest}"
      FileUtils.rm_rf(symlink_dest) # blow away original 3.0.0 folder

      # Create symlink that will point to the gems in the Lambda Layer:
      #   stage/opt/ruby/gems/3.0.0 -> /opt/ruby/gems/3.0.0
      FileUtils.mkdir_p(File.dirname(symlink_dest))
      FileUtils.ln_sf("/opt/ruby/gems/#{ruby_folder}", symlink_dest)
    end

    def ruby_folder
      major, minor, _ = RUBY_VERSION.split('.')
      [major, minor, '0'].join('.') # 3.0.1 => 3.0.0
    end

    # Remove the BUNDLED WITH line since we don't control the bundler gem version on AWS Lambda
    # And this can cause issues with require 'bundler/setup'
    def remove_bundled_with(gemfile_lock)
      lines = IO.readlines(gemfile_lock)

      # amount is the number of lines to remove
      new_lines, capture, count, amount = [], true, 0, 2
      lines.each do |l|
        capture = false if l.include?('BUNDLED WITH')
        if capture
          new_lines << l
        end
        if capture == false
          count += 1
          capture = count > amount # renable capture
        end
      end

      content = new_lines.join('')
      IO.write(gemfile_lock, content)
    end

    def gemfile_exist?
      gemfile_path = "#{@files.full_path}/Gemfile"
      File.exist?(gemfile_path)
    end
  end
end
