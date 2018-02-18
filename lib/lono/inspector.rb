require "thor"

class Lono::Inspector
  autoload :Base, 'lono/inspector/base'
  autoload :Graph, 'lono/inspector/graph'
  autoload :Summary, 'lono/inspector/summary'
end
