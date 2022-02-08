class Lono::CLI
  class New < Lono::Command
    long_desc Help.text("new/blueprint")
    Blueprint.cli_options.each { |args| option(*args) }
    register(Blueprint, "blueprint", "blueprint NAME", "Generates new blueprint.")

    long_desc Help.text("new/configset")
    Configset.cli_options.each { |args| option(*args) }
    register(Configset, "configset", "configset NAME", "Generates new configset.")

    long_desc Help.text("new/extension")
    Extension.cli_options.each { |args| option(*args) }
    register(Extension, "extension", "extension NAME", "Generates new extension.")

    long_desc Help.text("new/helper")
    Helper.cli_options.each { |args| option(*args) }
    register(Helper, "helper", "helper NAME", "Generates new helper.")

    long_desc Help.text("new/project")
    Project.cli_options.each { |args| option(*args) }
    register(Project, "project", "project NAME", "Generates new project.")

    long_desc Help.text("new/shim")
    Shim.cli_options.each { |args| option(*args) }
    register(Shim, "shim", "shim NAME", "Generates new shim.")

    desc "test SUBCOMMAND", "test subcommands"
    long_desc Help.text(:test)
    subcommand "test", Test
  end
end
