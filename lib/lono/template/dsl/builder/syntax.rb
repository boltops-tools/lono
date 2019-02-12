# Organize core syntax here
class Lono::Template::Dsl::Builder
  module Syntax
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
      definition.map! { |x| CfnCamelizer.camelize(x) }
      @cfn["Transform"] = definition.size == 1 ? definition.first : definition
    end

    def parameter(*definition)
      @cfn["Parameters"] ||= {}
      param = Parameter.new(definition)
      @cfn["Parameters"].merge!(param.template)
    end

    def mapping(*definition)
      @cfn["Mappings"] ||= {}
      mapping = Mapping.new(definition)
      @cfn["Mappings"].merge!(mapping.template)
    end

    def resource(*definition)
      @cfn["Resources"] ||= {}
      resource = Resource.new(definition)
      @cfn["Resources"].merge!(resource.template)
    end

    def condition(*definition)
      @cfn["Conditions"] ||= {}
      condition = Condition.new(definition)
      @cfn["Conditions"].merge!(condition.template)
    end

    def output(*definition)
      @cfn["Outputs"] ||= {}
      output = Output.new(definition)
      @cfn["Outputs"].merge!(output.template)
    end

    # Generic section method in case CloudFormation adds a new future section.
    # The generic section method adds a new top-level key
    def section(key, definition)
      @cfn[key] = Section.new(definition).template
    end
  end
end
