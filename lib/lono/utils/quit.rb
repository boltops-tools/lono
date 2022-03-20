module Lono::Utils
  module Quit
    def quit(code)
      ENV['LONO_TEST'] ? raise : exit(code)
    end
  end
end
