module Lono::Configset::Materializer
  class Final
    def build(jades)
      return if jades.empty?
      list = jades.map(&:name).uniq.join(", ") # possible to have different versions. only showing names and removing duplicates
      puts "Materializing #{list}..."
      GemsBuilder.new(jades).build
    end
  end
end
