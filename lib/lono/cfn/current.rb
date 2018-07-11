require "yaml"

class Lono::Cfn
  class Current
    def initialize(options={})
      Lono::ProjectChecker.check_lono_project
      @options = options
      @file = ".lono/current"
      @path = "#{Lono.root}/#{@file}"
    end

    def run
      @options[:rm] ? rm : set
    end

    def rm
      FileUtils.rm_f(@path)
      puts "Current settings have been removed. Removed #{@file}"
    end

    def set
      if @options.empty?
        show
      else
        d = data # assign data to d to create local variable for merge to work
        d = d.merge(@options).delete_if do |k,v|
          v&.empty? || v == ['']
        end
        text = YAML.dump(d)
        FileUtils.mkdir_p(File.dirname(@path))
        IO.write(@path, text)
        puts "Current settings saved in .lono/current"
        show
      end
    end

    def show
      if data.empty?
        puts <<-EOL
There are no current settings.  To set a current stack run:

    lono cfn current --name mystack
    lono cfn current -h # for more examples
EOL
        return
      end

      data.each do |key, value|
        puts "Current #{key}: #{value}"
      end
    end

    def data
      YAML.load(IO.read(@path)) rescue {}
    end

    def suffix
      current = data["suffix"]
      return current unless current&.empty?
    end

    # reads suffix, returns nil if not set
    def self.suffix
      Current.new.suffix
    end

    def name
      current = data["name"]
      return current unless current&.empty?
    end

    # reads name, returns nil if not set
    def self.name
      Current.new.name
    end

    # reads name, will exit if current name not set
    def self.name!(name=:current)
      return name if name != :current

      name = Current.name
      return name if name

      # TODO: don't think it is possible to get here...
      puts "ERROR: stack name must be specified.".colorize(:red)
      puts <<-EOL
Example:
    lono cfn #{ARGV[1]} STACK
You can also set a current stack name to be remembered with:
    lono cfn current --name STACK
EOL
      exit 1
    end
  end
end
