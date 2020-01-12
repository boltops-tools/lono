module Lono::Configset::Register
  class Blueprint < Base
    self.configsets = []
    self.validations = []

    def evaluate
      path = find_configsets
      evaluate_file(path)
    end

    def find_configsets
      path = "#{Lono.blueprint_root}/config/configsets.rb"
      path if File.exist?(path)
    end
  end
end
