module Lono
  class Upgrade
    def initialize(options)
      @options = options
    end

    def run
      app_blueprints_move # v6 to v7
      puts "Lono project upgraded"
    end

    def app_blueprints_move
      return if File.exist?("#{Lono.root}/app/blueprints")
      return unless File.exist?("#{Lono.root}/blueprints")

      FileUtils.mv("#{Lono.root}/blueprints", "#{Lono.root}/app/blueprints")
      puts "Move blueprints to app/blueprints"
    end
  end
end
