class Lono::CLI
  module Help
    extend ActiveSupport::Concern

    class_methods do
      def main_commands
        %w[
          build
          down
          list
          new
          plan
          seed
          show
          up
        ]
      end

      def help(shell, subcommand)
        list = printable_commands(true, subcommand)
        list.sort! { |a, b| a[0] <=> b[0] }
        filter = Proc.new do |command, desc|
          main_commands.detect { |name| command =~ Regexp.new("^lono #{name}") }
        end
        main = list.select(&filter)
        other = list.reject(&filter)

        shell.say <<~EOL
          Usage: lono COMMAND [args]
          The available commands are listed below.
          The primary workflow commands are given first, followed by
          less common or more advanced commands.
        EOL
        shell.say "\nMain Commands:\n\n"
        shell.print_table(main, :indent => 2, :truncate => true)
        shell.say "\nOther Commands:\n\n"
        shell.print_table(other, :indent => 2, :truncate => true)
        shell.say <<~EOL

          For more help on each command, you can use the -h option. Example:

              lono up -h

          CLI Reference also available at: https://lono.cloud/reference/
        EOL
      end
    end

    def text(namespaced_command)
      path = namespaced_command.to_s.gsub(':','/')
      path = File.expand_path("../help/#{path}.md", __FILE__)
      IO.read(path) if File.exist?(path)
    end
    extend self
  end
end
