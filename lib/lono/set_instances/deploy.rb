class Lono::SetInstances
  class Deploy < Changeable
    def run
      # computes whether create or update should be ran for stack instances within each account
      updates, creates = Hash.new([]), Hash.new([])
      accounts.each do |account|
        regions.each do |region|
          if stack_instance_exists?(account, region)
            updates[account] += [region] # += [item] works, << item doesnt seem to work
          else
            creates[account] += [region] # += [item] works, << item doesnt seem to work
          end
        end
      end

      deploy(:create, creates)
      deploy(:update, updates)
    end

    def deploy(type, changes)
      changes.each do |account, regions|
        run_action(type, account, regions)
      end
    end

    def run_action(type, account, regions)
      klass = "Lono::SetInstances::#{type.to_s.camelize}"
      klass = klass.constantize
      command = lono_command(klass)
      puts "Running #{command.color(:green)} on account: #{account} regions: #{regions.join(',')}"

      options = @options.dup
      options[:accounts] = [account]
      options[:regions] = regions
      klass.new(options).run
    end

    def lono_command(klass)
      klass = klass.to_s
      klass.split('::').map(&:underscore).join(' ')
    end

    def stack_instance_exists?(account, region)
      existing = stack_instances.map do |summary|
        [summary.account, summary.region]
      end
      intersect = existing & [[account, region]]
      !intersect.empty?
    end

  end
end
