class Lono::CLI
  class New < Lono::Command
    long_desc Help.text("new/blueprint")
    Blueprint.cli_options.each { |args| option(*args) }
    register(Blueprint, "blueprint", "blueprint NAME", "Generate new blueprint")

    long_desc Help.text("new/configset")
    Configset.cli_options.each { |args| option(*args) }
    register(Configset, "configset", "configset NAME", "Generate new configset")

    long_desc Help.text("new/helper")
    Helper.cli_options.each { |args| option(*args) }
    register(Helper, "helper", "helper NAME", "Generate new helper")

    long_desc Help.text("new/hook")
    Hook.cli_options.each { |args| option(*args) }
    register(Hook, "hook", "hook NAME", "Generate new hook")

    long_desc Help.text("new/project")
    Project.cli_options.each { |args| option(*args) }
    register(Project, "project", "project NAME", "Generate new project")

    long_desc Help.text("new/shim")
    Shim.cli_options.each { |args| option(*args) }
    register(Shim, "shim", "shim NAME", "Generate new shim")

    desc "test SUBCOMMAND", "test subcommands"
    long_desc Help.text(:test)
    subcommand "test", Test
  end
end
