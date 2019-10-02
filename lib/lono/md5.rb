require "digest"

# 1. md5sum the file or zipfile - shared
# 2. add prefix and md5sum - shared, lets break out prefix adding logic to elsewhere

# Using md5sum on the zipped file will an always changing value since the timestamp and other metadata of the zipfile
# changes whenever we create it.
#
# This is custom checksum logic that only accounts for the contents of the files in the directory.
module Lono
  class Md5
    class << self
      extend Memoist

      # This checksum within the file name is to mainly make sure that Lambda::Function resources "change" and an update is triggered.
      # There's another checksum in the upload code that makes sure we don't upload the code again to speed up things.
      def sum(path)
        files = Dir["#{path}/**/*"]
        files = files.reject { |f| File.directory?(f) }
                     .reject { |f| File.symlink?(f) }
        files.sort!
        content = files.map do |f|
          Digest::MD5.file(f).to_s[0..7]
        end.join

        md5 = Digest::MD5.new
        md5.update(content)
        md5.hexdigest.to_s[0..7]
      end
      memoize :sum

      def name(path)
        relative_path = name_without_md5(path)
        relative_path = relative_path.sub(/\.(\w+)$/,'') # strip extension
        ext = File.directory?(path) ? "zip" : $1
        md5 = sum(path)
        "#{relative_path}-#{md5}.#{ext}"
      end

      def name_without_md5(path)
        regexp = %r{.*/output/[\w_-]+/files/}
        path.sub(regexp, '') # relative_path w/o md5
      end
    end
  end
end
