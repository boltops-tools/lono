class Lono::CLI
  class Seed < Lono::CLI::Base
    def create
      logger.info "Creating starter config files for #{@blueprint.name}"
      seeder = Lono::Seeder.new(@options)
      seeder.run
    end
  end
end
