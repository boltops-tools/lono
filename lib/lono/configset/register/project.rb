module Lono::Configset::Register
  class Project < Base
    self.configsets = []
    self.validations = []

    def evaluate
      layering = Lono::Layering.new("configsets", @options, Lono.env)
      layering.locations.each do |path|
        evaluate_file(path)
      end
    end
  end
end
