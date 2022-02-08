class Lono::AppFile::Registry
  # Holds metadata about the item in the regsitry.
  class Item
    include Lono::Utils::Item::FileMethods

    attr_reader :name, :options, :type
    def initialize(name, blueprint, options={})
      @name, @blueprint.name, @options = name, blueprint, options
      @type = options[:type] || "file"
    end

    def src_path
      "#{@blueprint.root}/app/files/#{@name}"
    end

    def output_path
      if @type == "file"
        "#{Lono.root}/output/#{@blueprint.name}/files/#{@name}"
      else
        "#{Lono.root}/output/#{@blueprint.name}/lambda_layers/#{@name}/opt"
      end
    end
  end
end
