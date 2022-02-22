# Built-in helpers for the DSL form
class Lono::Builder::Dsl
  module Helpers
    extend Memoist

    # Auto include all modules in helpers folder
    # only load one level deep. IE: ssm/fetcher is a class
    helpers_dir = File.expand_path("helpers", __dir__)
    Dir.glob("#{helpers_dir}/*.rb").each do |path|
      next unless File.file?(path)
      klass = path.gsub(%r{.*/lib/},'').sub(".rb",'').camelize
      include klass.constantize
    end
  end
end
