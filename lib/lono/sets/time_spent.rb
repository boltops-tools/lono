class Lono::Sets
  module TimeSpent
    include Lono::Utils::PrettyTime

    def show_time_spent(stack_set_operation)
      seconds = stack_set_operation.end_timestamp - stack_set_operation.creation_timestamp
      time_took = pretty_time(seconds).color(:green)
      puts "Time took to complete stack set operation: #{time_took}"
    end
  end
end
