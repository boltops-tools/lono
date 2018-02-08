require 'pathname'

module Lono
  module Core
    def env
      ENV['LONO_ENV'] || 'development'
    end

    def root
      path = ENV['LONO_ROOT'] || '.'
      Pathname.new(path)
    end
  end
end
