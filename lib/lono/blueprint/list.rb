class Lono::Blueprint
  class List
    class << self
      def available
        puts "Current available blueprints:"
        Find.all_blueprints.each do |b|
          full_path = Find.find(b)
          path = full_path.sub("#{Lono.root}/", "")
          puts "  #{b}: #{path}"
        end
      end
    end
  end
end