class Lono::CLI::New
  class Helper < Lono::Command
    Help = Lono::CLI::Help

    long_desc Help.text("new/helper/blueprint")
    Blueprint.cli_options.each { |args| option(*args) }
    register(Blueprint, "blueprint", "blueprint HELPER_NAME --blueprint", "Generates new blueprint helper")

    long_desc Help.text("new/helper/project")
    Project.cli_options.each { |args| option(*args) }
    register(Project, "project", "project HELPER_NAME", "Generates new project helper")
  end
end
