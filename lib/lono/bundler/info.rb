module Lono::Bundler
  class Info < CLI::Base
    def run
      file = LB.config.lockfile
      unless File.exist?(file)
        logger.info "No #{file} found".color(:red)
        logger.info "Maybe run: lono bundle"
        return
      end

      name = @options[:component]
      all = lockfile.components.find_all { |c| c.name == @options[:component] }
      all = all.select { |c| c.type == @options[:type] } if @options[:type]
      if all.size > 1
        logger.info "Multiple components found with different types"
      end

      all.each do |found|
        show(found)
      end
      unless all.size > 0
        logger.info "Could not find component in #{LB.config.lockfile}: #{name}".color(:red)
      end
    end

    def show(component)
      props = component.props.reject { |k,v| k == :name }.stringify_keys # for sort
      puts "#{component.name}:"
      props.keys.sort.each do |k|
        v = props[k]
        puts "    #{k}: #{v}" unless v.blank?
      end
    end

    def lockfile
      Lockfile.instance
    end
  end
end
