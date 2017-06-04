class Lono::Cfn::Help
  class << self
    def create
<<-EOL
Examples:

Provided that you are in a lono project and have a `my-stack` lono template definition.  To create a stack you can simply run:

$ lono cfn create my-stack

The above command will generate and use the template in output/my-stack.json and parameters in params/my-stack.txt.  The template by convention defaults to the name of the stack.  In turn, the params by convention defaults to the name of the template.

Here are examples of overriding the template and params name conventions.

$ lono cfn create my-stack --template different-name1

The template that will be use is output/different-name1.json and the parameters will use params/different-name1.json.

$ lono cfn create my-stack --params different-name2

The template that will be use is output/different-name2.json and the parameters will use params/different-name2.json.

$ lono cfn create my-stack --template different-name3 --params different-name4

The template that will be use is output/different-name3.json and the parameters will use params/different-name4.json.

EOL
    end

    def update
<<-EOL
Examples:

Provided that you are in a lono project and have a `my-stack` lono template definition.  To update a stack you can simply run:

$ lono cfn update my-stack

The above command will generate and use the template in output/my-stack.json and parameters in params/my-stack.txt.  The template by convention defaults to the name of the stack.  In turn, the params by convention defaults to the name of the template.

Here are examples of overriding the template and params name conventions.

$ lono cfn update my-stack --template different-name1

The template that will be use is output/different-name1.json and the parameters will use params/different-name1.json.

$ lono cfn update my-stack --params different-name2

The template that will be use is output/different-name2.json and the parameters will use params/different-name2.json.

$ lono cfn update my-stack --template different-name3 --params different-name4

The template that will be use is output/different-name3.json and the parameters will use params/different-name4.json.

EOL
    end

    def delete
<<-EOL
Examples:

$ lono cfn delete my-stack

The above command will delete my-stack.
EOL
    end

    def preview
<<-EOL
Generates a CloudFormation preview.  This is similar to a `terraform plan` or puppet's dry-run mode.

Example output:

CloudFormation preview for 'example' stack update. Changes:

Remove AWS::Route53::RecordSet: DnsRecord testsubdomain.sub.tongueroo.com

Examples:

$ lono cfn preview my-stack
EOL
    end

    def diff
<<-EOL
Displays code diff of the generated CloudFormation template locally vs the existing template on AWS. You can set a desired diff viewer by setting the LONO_CFN_DIFF environment variable.

Examples:

$ lono cfn diff my-stack
EOL
    end
  end
end
