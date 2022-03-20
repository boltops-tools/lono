class Lono::App
  class Inits
    class << self
      include DslEvaluator

      def run_all
        Dir.glob("#{Lono.root}/config/inits/*.rb").each do |path|
          evaluate_file(path)
        end
      end
    end
  end
end
