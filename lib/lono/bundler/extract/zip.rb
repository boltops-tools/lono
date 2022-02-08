require 'rubygems'
require 'zip'

class Lono::Bundler::Extract
  class Zip
    def self.extract(file, dest)
      ::Zip::File.open(file) { |zip_file|
        zip_file.each { |f|
          f_path=File.join(dest, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        }
      }
    end
  end
end
