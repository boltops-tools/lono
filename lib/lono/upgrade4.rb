require 'fileutils'
require 'yaml'

module Lono
  class Upgrade4
    def initialize(options)
      @options = options
    end

    def run
      checks
      puts "Upgrading structure of your current project to the new lono version 4 project structure"

      upgrade_settings("config/settings.yml")
      upgrade_settings("#{ENV['HOME']}/.lono/settings.yml")
      add_mandantory_settings

      FileUtils.mkdir_p("app")
      mv("helpers", "app/helpers")
      mv("params", "config/params")
      mv("config/templates", "app/stacks")
      mv("templates", "app/templates")
      mv("app/templates/partial", "app/partials")
      update_variables
      update_stacks

      puts "Upgrade complete."
    end

    def update_stacks
      update_structure("app/stacks")
    end

    def update_variables
      update_structure("config/variables")
    end

    # Takes variable files in the subfolder like config/variables/production/*
    # and combines the into a single file like config/variables/production.rb.
    #
    #   config/variables/base/* -> config/variables/base.rb
    #   config/variables/development/* -> config/variables/development.rb
    #   config/variables/production/* -> config/variables/production.rb
    #   app/stacks/base/* -> app/stacks/base.rb
    #   app/stacks/development/* -> app/stacks/development.rb
    #   app/stacks/production/* -> app/stacks/production.rb
    def update_structure(component_path)
      puts "Updating structure of #{component_path}"
      Dir.glob("#{component_path}/*").each do |path|
        next unless File.directory?(path)
        folder = File.basename(path)
        update_structure_for(component_path, folder)
      end

      # remove the old folders
      Dir.glob("#{component_path}/*").each do |path|
        next unless File.directory?(path)
        FileUtils.rm_rf(path)
      end
    end

    # combines the files in the env_group subfolder into one file
    def update_structure_for(component_path, env_group)
      code = ""
      Dir.glob("#{component_path}/#{env_group}/*.rb").each do |path|
        code << IO.read(path)
        code << "\n"
      end
      IO.write("#{component_path}/#{env_group}.rb", code)
    end

    def checks
      if File.exist?(Lono.config.stacks_path)
        puts "It looks like you already have a #{Lono.config.stacks_path} folder in your project. This is the new project structure so exiting without updating anything."
        exit
      end

      old_templates_path = "#{Lono.root}/config/templates"
      if !File.exist?(old_templates_path)
        puts "Could not find a #{old_templates_path} folder in your project. Maybe you want to run lono new to initialize a new lono project instead?"
        exit
      end
    end

    def upgrade_settings(path)
      return unless File.exist?(path)

      data = YAML.load_file(path)
      return if data.key?("base") # already in new format

      new_structure = {}

      (data["aws_profile_lono_env_map"] || {}).each do |aws_profile, lono_env|
        new_structure[lono_env] ||= {}
        new_structure[lono_env]["aws_profiles"] ||= []
        new_structure[lono_env]["aws_profiles"] << aws_profile
      end
      data.delete("aws_profile_lono_env_map")

      (data["lono_env_cluster_map"] || {}).each do |lono_env, cluster|
        new_structure[lono_env] ||= {}
        new_structure[lono_env]["cluster"] = cluster
      end
      data.delete("lono_env_cluster_map")

      data = update_s3_setting(data)

      new_structure["base"] = data
      text = YAML.dump(new_structure)
      IO.write(path, text)
      puts "Upgraded settings: #{path}"
      if path.include?(ENV['HOME'])
        puts "NOTE: Your ~/.lono/settings.yml file was also upgraded to the new format. If you are using lono in other projects those will have to be upgraded also."
      end
    end

    # accounts for most cases
    def update_s3_setting(data)
      return data unless data["s3"] && data["s3"]["path"]

      options = data["s3"]["path"]
      if options.is_a?(String)
        data.delete("s3")
        data["s3_path"] = options
        return data # return early if String
      end

      # Reach here: dealing with a Hash
      if options.size == 1 and options["default"]
        data["s3_path"] = options["default"]
      end

      if options.size > 1
        data["s3_path"] = {}
        options.each do |key, value|
          data["s3_path"][key] = value
        end
      end

      data.delete("s3")
      data
    end

    # If config/settings.yml does not exist, use the default one.
    def add_mandantory_settings
      return if File.exists?("config/settings.yml")

      default_settings = File.expand_path("default/settings.yml", File.dirname(__FILE__))
      FileUtils.cp(default_settings, "config/settings.yml")
    end

    def mv(src, dest)
      return unless File.exist?(src)
      puts "mv #{src} #{dest}"
      FileUtils.mv(src, dest)
    end
  end
end
