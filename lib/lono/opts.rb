# Note moving this under Lono::CLI::Opts messes with the zeitwerk autoloader.
# A weird workaround is calling Lono::CLI::Opts right after the autoloader and then it seems to fix itself.
# It may be because there's a custom infleciton cli => CLI. Unsure.
# Unsure if there are other side-effects with the workaround so named this:
# Lono::Opts instead of Lono::CLI::Opts
#
# Also, there's Thor Options class, so this is named Opts to avoid having to fully qualify it.
module Lono
  class Opts
    def initialize(cli)
      @cli = cli
    end

    def clean
      with_cli_scope do
        option :clean, type: :boolean, default: true, desc: "remove all output files before generating"
      end
    end

    def source
      with_cli_scope do
        option :source, desc: "url or path to file with template"
      end
    end

    def stack
      with_cli_scope do
        option :stack, desc: "stack name. defaults to blueprint name."
      end
    end

    def template
      with_cli_scope do
        option :template, desc: "override convention and specify the template file to use"
      end
    end

  private
    def with_cli_scope(&block)
      @cli.instance_eval(&block)
    end
  end
end
