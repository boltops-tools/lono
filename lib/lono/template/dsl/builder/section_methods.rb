# Organize core section method syntax here
class Lono::Template::Dsl::Builder
  module SectionMethods
    def aws_template_format_version(version_date)
      @cfn["AWSTemplateFormatVersion"] = version_date
    end

    def description(text)
      @cfn["Description"] = text
    end

    def metadata(data)
      @cfn["Metadata"] = data
    end

    def transform(*definition)
      definition = definition.flatten
      @cfn["Transform"] = definition.size == 1 ? definition.first : definition
    end

    def parameter(*definition)
      @cfn["Parameters"] ||= {}
      param = Parameter.new(@blueprint, definition)
      @cfn["Parameters"].merge!(param.template)
    end

    def mapping(*definition)
      @cfn["Mappings"] ||= {}
      mapping = Mapping.new(@blueprint, definition)
      @cfn["Mappings"].merge!(mapping.template)
    end

    def resource(*definition)
      @cfn["Resources"] ||= {}
      resource = Resource.new(@blueprint, definition)
      @cfn["Resources"].merge!(resource.template)
    end

    def condition(*definition)
      @cfn["Conditions"] ||= {}
      condition = Condition.new(@blueprint, definition)
      @cfn["Conditions"].merge!(condition.template)
    end

    def output(*definition)
      @cfn["Outputs"] ||= {}
      output = Output.new(@blueprint, definition)
      @cfn["Outputs"].merge!(output.template)
    end

    # Generic section method in case CloudFormation adds a new future section.
    # The generic section method adds a new top-level key
    def section(key, definition)
      @cfn[key] = Section.new(@blueprint, definition).template
    end
  end
end
