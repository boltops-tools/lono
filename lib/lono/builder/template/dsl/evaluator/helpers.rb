# Built-in helpers for the DSL form
class Lono::Builder::Template::Dsl::Evaluator
  module Helpers
    extend Memoist

    # Auto include all modules in helpers folder
    helpers_dir = File.expand_path("helpers", __dir__)
    Dir.glob("#{helpers_dir}/**/*").each do |path|
      next unless File.file?(path)
      klass = path.gsub(%r{.*/lib/},'').sub(".rb",'').camelize
      include klass.constantize
    end

    include Lono::Builder::Template::Helpers
  end
end
