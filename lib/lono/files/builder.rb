class Lono::Files
  class Builder < Base
    extend Memoist
    include Lono::Builder::Context
    include Lono::Builder::Dsl::Syntax
    # Tricky must define files again to avoid conflict with files from loading the Dsl::Syntax
    attr_reader :files

    def run
      load_context
      if File.directory?(full_path)
        directory(@files)
      else
        template(@files)
      end
    end

    def template(files)
      sequence.send(:set_template_paths, @blueprint.root)
      src = files.path
      dest = files.output_path
      sequence.template(src, dest)
    end

    def directory(files)
      src = files.full_path
      sequence.send(:set_template_paths, src)
      sequence.destination_root = @files.output_path
      sequence.directory(".", verbose: false, force: true, context: binding) # Thor::Action
    end

    def sequence
      Lono::CLI::New::Sequence.new(@options)
    end
    memoize :sequence
  end
end
