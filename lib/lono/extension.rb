module Lono
  class Extension < Command
    long_desc Help.text("extension/new")
    New.cli_options.each do |args|
      option(*args)
    end
    register(New, "new", "new NAME", "Generates new lono extension.")
  end
end
