# Note moving this under Lono::CLI::Opts messes with the zeitwerk autoloader.
# A weird workaround is calling Lono::CLI::Opts right after the autoloader and then it seems to fix itself.
# It may be because there's a custom infleciton cli => CLI. Unsure.
# Unsure if there are other side-effects with the workaround so named this:
# Lono::Opts instead of Lono::CLI::Opts
#
# Also, there's Thor Options class, so this is named Opts to avoid having to fully qualify it.
class Lono::CLI
  class Opts
    def initialize(cli)
      @cli = cli
    end

    def clean
      with_cli_scope do
        option :clean, type: :boolean, default: true, desc: "remove all output files before generating"
      end
    end

    def yes
      with_cli_scope do
        option :yes, aliases: :y, type: :boolean, desc: "Bypass are you sure prompt"
      end
    end

    # Based on https://github.com/rails/thor/blob/ab3b5be455791f4efb79f0efb4f88cc6b59c8ccf/lib/thor/actions.rb#L48
    def runtime_options
      with_cli_scope do
        option :force, :type => :boolean, :aliases => "-f", :group => :runtime,
                             :desc => "Overwrite files that already exist"

        option :skip, :type => :boolean, :aliases => "-s", :group => :runtime,
                            :desc => "Skip files that already exist"
      end
    end

  private
    def with_cli_scope(&block)
      @cli.instance_eval(&block)
    end
  end
end
