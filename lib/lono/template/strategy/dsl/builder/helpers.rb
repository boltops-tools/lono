# Built-in helpers for the DSL form
class Lono::Template::Strategy::Dsl::Builder
  module Helpers
    extend Memoist

    # Auto include all modules in helpers folder
    helpers_dir = File.expand_path("helpers", __dir__)
    Dir.glob("#{helpers_dir}/**/*").each do |path|
      next unless File.file?(path)
      klass = path.gsub(%r{.*/lib/},'').sub(".rb",'').camelize
      include klass.constantize
    end

    include Lono::Template::Strategy::Common::Helpers
  end
end
