module Lono
  class Starter < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean
    class_option :mute, type: :boolean

    desc "configs", "Generate starter configs files."
    long_desc Lono::Help.text("starter/configs")
    def configs(blueprint=nil)
      Blueprint::Find.one_or_all(blueprint).each do |b|
        Configs.new(b, options).create
      end
    end
  end
end
