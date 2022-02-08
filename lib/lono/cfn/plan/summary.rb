class Lono::Cfn::Plan
  class Summary
    include Lono::Utils::Logging

    def print(resource_types)
      types = resource_types.sort_by {|r| r[0]} # Hash -> 2D Array
      types.each do |a|
        type, count = a
        logger.info "%3s %s" % [count, type]
      end
      total = types.inject(0) { |sum,(type,count)| sum += count }
      logger.info "%3s %s" % [total, "Total"]
      logger.info "" # newline
    end
  end
end
