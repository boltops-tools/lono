## Examples

    lono import /path/to/file
    lono import http://url.com/path/to/template.json
    lono import http://url.com/path/to/template.yml

## Example Output

    $ lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/EC2InstanceWithSecurityGroupSample.template --name ec2
    => Imported CloudFormation template and lono-fied it.
    Template definition added to app/definitions/base.rb
    Params file created to config/params/base/ec2.txt
    Template downloaded to app/templates/ec2.yml
    => CloudFormation Template Summary:
    Parameters:
    Required:
      KeyName (AWS::EC2::KeyPair::KeyName)
    Optional:
      InstanceType (String) Default: t2.small
      SSHLocation (String) Default: 0.0.0.0/0
    Resources:
      1 AWS::EC2::Instance
      1 AWS::EC2::SecurityGroup
      2 Total
    Here are contents of the params config/params/base/ec2.txt file:
    KeyName=
    #InstanceType=        # optional
