class Lono::CLI
  class Iam < Base
    include Lono::Cfn::Concerns::Build
    include Lono::Cfn::Concerns::TemplateOutput

    def run
      build.template_builder.run
      resources = template_output.data['Resources']
      types = resources.map { |logical_id, attrs| attrs['Type'] }
      actions = types.map do |t|
        service = t.split('::')[1]
        "#{service.downcase}:*"
      end.uniq
      text =<<~EOL
        Version: 2012-10-17
        Statement:
        - Sid: #{@blueprint.name}
          Effect: Allow
          Resource: "*"
      EOL
      policy = YAML.load(text)
      policy['Statement'][0]['Action'] = actions
      puts "IAM Policy Example for blueprint #{@blueprint.name}".color(:green)
      puts JSON.pretty_generate(policy)
    end
  end
end
