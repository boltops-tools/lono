# Autoscaling Lono Example

## Usage

Create a new project.

```
TEMPLATE=ec2 lono new ec2
cd ec2
```

Edit `config/params/base/ec2.txt` with your desired parameters. Here are the current contents of ``config/params/base/ec2.txt`:

```sh
InstanceType=t2.micro
KeyName=default
```

Then launch the stack:

```sh
lono cfn create ec2
```

## How This Example Was Orginally Built

First, generate a skeleton starter lono project.

```sh
TEMPLATE=skeleton lono new ec2
```

Then import a standard CloudFormation template into lono. The `--name` option is used to name the template `ec2`.

```
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
#SSHLocation=         # optional
```

The template was imported from [https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c23c48c13c15).

A starter `config/params/base/ec2.txt` was generated with required parameters emptied and optional parameters commented out.  Fill in the required parameters.

### Filling in the Parameters

You can use the following commands to set KeyName to a key that exists on your AWS account.  Here we use `default` :

```
sed "s/KeyName=/KeyName=default/" config/params/base/ec2.txt > config/params/base/ec2.txt.1
mv config/params/base/ec2.txt{.1,}
```

Now launch the stack:

```
lono cfn create ec2
```

## Commands Summarized

```sh
lono new ec2
cd ec2
lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/EC2InstanceWithSecurityGroupSample.template --name ec2
sed "s/KeyName=/KeyName=default/" config/params/base/ec2.txt > config/params/base/ec2.txt.1
mv config/params/base/ec2.txt{.1,}
lono cfn create ec2 --template ec2
```
