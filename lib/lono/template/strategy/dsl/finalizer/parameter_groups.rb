class Lono::Template::Strategy::Dsl::Finalizer
  class ParameterGroups
    extend Memoist
    include Lono::Template::Strategy::Dsl::Builder::Stringify

    def initialize(cfn, parameters)
      @cfn, @parameters = cfn, parameters
    end

    def run
      return @cfn if parameter_groups.empty?
      @cfn["Metadata"] ||= {}
      @cfn["Metadata"]["AWS::CloudFormation::Interface"] = stringify!(interface)
      @cfn
    end

    def interface
      interface = {}
      parameter_groups.each do |group_label, parameters|
        group = {
          Label: { default: group_label},
          Parameters: parameters,
        }
        interface[:ParameterGroups] ||= []
        interface[:ParameterGroups] << group
      end
      parameter_labels.each do |name, label|
        l = { name => { default: label } }
        interface[:ParameterLabels] ||= {}
        interface[:ParameterLabels].merge!(l)
      end
      interface
    end

    def parameter_groups
      parameter_groups = {}
      @parameters.each do |p|
        next unless p.group_label
        parameter_groups[p.group_label] ||= []
        parameter_groups[p.group_label] << p.name
      end
      parameter_groups
    end
    memoize :parameter_groups

    def parameter_labels
      parameter_labels = {}
      @parameters.each do |p|
        next unless p.label
        parameter_labels[p.name] = p.label
      end
      parameter_labels
    end
    memoize :parameter_labels
  end
end
