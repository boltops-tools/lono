class Lono::Builder::Allow
  class Region < Base
    include Lono::Concerns::AwsInfo

    # interface method
    def message
      messages = []
      word = config_name.to_s # IE: regions or locations
      messages << "This #{word.singularize} is not allowed to be used: Detected current #{word.singularize}=#{current_region}"
      messages << "Allow #{word}: #{allows.join(', ')}" if allows
      messages << "Deny #{word}: #{denys.join(', ')}" if denys
      messages.join("\n")
    end

    # interface method
    def check_value
      region
    end
  end
end
