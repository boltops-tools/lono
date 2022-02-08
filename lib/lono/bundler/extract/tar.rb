require 'rubygems/package'
require 'zlib'
require 'fileutils'

# Thanks: https://gist.github.com/ForeverZer0/2adbba36fd452738e7cca6a63aee2f30
class Lono::Bundler::Extract
  class Tar
    # tar_gz_archive = '/tmp/lono/bundler/stage/s3-us-west-2.amazonaws.com/demo-terraform-test/blueprints/example-module.tgz'
    # destination = '/tmp/lono/where/extract/to'
    def self.extract(tar_gz_archive, destination)
      reader = Zlib::GzipReader.open(tar_gz_archive)
      Gem::Package::TarReader.new(reader) do |tar|
        dest = nil
        tar.each do |entry|
          dest ||= File.join destination, entry.full_name
          if entry.directory?
            FileUtils.rm_rf dest unless File.directory? dest
            FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
          elsif entry.file?
            FileUtils.rm_rf dest unless File.file? dest
            File.open dest, "wb" do |f|
              f.print entry.read
            end
            FileUtils.chmod entry.header.mode, dest, :verbose => false
          elsif entry.header.typeflag == '2' #Symlink!
            File.symlink entry.header.linkname, dest
          end
          dest = nil
        end
      end
    end
  end
end
