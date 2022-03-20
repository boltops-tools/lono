class Lono::CLI::New
  class Test < Lono::Command
    Help = Lono::CLI::Help
    long_desc Help.text("new/test/blueprint")
    Blueprint.cli_options.each { |args| option(*args) }
    register(Blueprint, "blueprint", "blueprint NAME", "Generate new blueprint test.")
  end
end
