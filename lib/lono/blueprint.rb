module Lono
  class Blueprint < Component
    def output_path
      "#{Lono.root}/output/#{@name}/template.yml"
    end
  end
end
