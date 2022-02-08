The `lono summary` command helps you quickly understand a CloudFormation template.

## Examples

    $ bundle exec lono summary ec2
    Building template
        output/ec2/templates/ec2-old.yml
        output/ec2/templates/ec2-new.yml
    => CloudFormation Template Summary for template ec2-new:
    Required Parameters (0):
        There are no required parameters.
    Optional Parameters (3):
        InstanceType (String) Default: t3.micro
        Subnet (String) Default:
        Vpc (String) Default:
    Resources:
        1 AWS::EC2::Instance
        1 AWS::EC2::SecurityGroup
        2 Total
    => CloudFormation Template Summary for template ec2-old:
    Required Parameters (0):
        There are no required parameters.
    Optional Parameters (3):
        InstanceType (String) Default: t3.micro
        Subnet (String) Default:
        Vpc (String) Default:
    Resources:
        1 AWS::EC2::Instance
        1 AWS::EC2::SecurityGroup
        2 Total
    $

Blog Post also covers this: [lono summary Tutorial Introduction](https://blog.boltops.com/2017/09/18/lono-inspect-summary-tutorial-introduction)
