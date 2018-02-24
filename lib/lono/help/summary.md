## Example

    $ lono summary ec2
    => CloudFormation Template Summary:
    Parameters:
    Required:
      KeyName (AWS::EC2::KeyPair::KeyName)
    Optional:
      InstanceType (String) Default: t2.micro
      SSHLocation (String) Default: 0.0.0.0/0
    Resources:
      1 AWS::EC2::Instance
      1 AWS::EC2::SecurityGroup
      2 Total
    $
