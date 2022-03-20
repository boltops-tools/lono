module Lono::Utils
  module Sure
    def sure?(message, desc=nil)
      if @options[:yes]
        yes = 'y'
      else
        out = message
        if desc
          out += "\n#{desc}\nAre you sure? (y/N) "
        else
          out += " (y/N) "
        end
        print out
        yes = $stdin.gets
      end

      unless yes =~ /^y/
        puts "Whew! Exiting."
        exit 0
      end
    end
  end
end
