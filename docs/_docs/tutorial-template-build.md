---
title: Build the Template
---

### Download the Template

Let's build the CloudFormation template.  Copy and paste this [starter CloudFormation template](https://github.com/tongueroo/cloudformation-examples-lono/blob/master/templates/instance.yml) into `templates/instance.yml`.  Here's also a `wget` to download the file:

```sh
wget https://raw.githubusercontent.com/tongueroo/cloudformation-examples-lono/master/templates/instance.yml
mv instance.yml templates/instance.yml
```

### ERB Template vs CloudFormation Template

The starter template that was created above is more powerful than a standard CloudFormation template.  It is an ERB template which means it can contain loops, if statements and variables. Here is a good post covering ERB templates [An Introduction to ERB Templating](http://www.stuartellis.name/articles/erb/).

Here's what the ERB template looks like. Note that some of the source code has been shortened for brevity.

```yaml
---
AWSTemplateFormatVersion: '2010-09-09'
Description: 'AWS CloudFormation Sample Template EC2InstanceWithSecurityGroupSample:
...
Parameters:
  KeyName:
    Description: Name of an existing EC2 KeyPair to enable SSH access to the instance
    Type: AWS::EC2::KeyPair::KeyName
    ConstraintDescription: must be the name of an existing EC2 KeyPair.
  InstanceType:
    Description: WebServer EC2 instance type
...
<% if @route53 %>
  HostedZoneName:
    Description: The route53 HostedZoneName. For example, "mydomain.com."  Don't forget the period at the end.
    Type: String
  Subdomain:
    Description: The subdomain of the dns entry. For example, hello -> hello.mydomain.com, hello is the subdomain.
    Type: String
<% end %>
...
Resources:
  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType:
        Ref: InstanceType
...
<% if @route53 %>
  DnsRecord:
    Type: AWS::Route53::RecordSet
    Properties:
      HostedZoneName: !Ref 'HostedZoneName'
      Comment: DNS name for my instance.
      Name: !Join ['', [!Ref 'Subdomain', ., !Ref 'HostedZoneName']]
      Type: CNAME
      TTL: '900'
      ResourceRecords:
      - !GetAtt EC2Instance.PublicIp
<% end %>
Outputs:
  InstanceId:
    Description: InstanceId of the newly created EC2 instance
    Value:
      Ref: EC2Instance
...
```


Let's focus in on the variables in our template.  Variables available in the templates are indicated by a '@' character.  We can get a quick overview of them by searching for them with grep.

```sh
$ grep '@' templates/instance.yml
<% if @route53 %>
<% if @route53 %>
```

There are 2 `@route53` variables in the `templates/instance.yml`.  Let's provide a little context around the grep to get a better feel of their purpose.

```diff
$ grep -5 '@' templates/instance.yml
    MinLength: '9'
    MaxLength: '18'
    Default: 0.0.0.0/0
    AllowedPattern: "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
    ConstraintDescription: must be a valid IP CIDR range of the form x.x.x.x/x.
<% if @route53 %>
  HostedZoneName:
    Description: The route53 HostedZoneName. For example, "mydomain.com."  Don't forget the period at the end.
    Type: String
  Subdomain:
    Description: The subdomain of the dns entry. For example, hello -> hello.mydomain.com, hello is the subdomain.
--
--
      - IpProtocol: tcp
        FromPort: '22'
        ToPort: '22'
        CidrIp:
          Ref: SSHLocation
<% if @route53 %>
  DnsRecord:
    Type: AWS::Route53::RecordSet
    Properties:
      HostedZoneName: !Ref 'HostedZoneName'
      Comment: DNS name for my instance.
$
```

So in this downloaded template, there's an `<% if @route53 %>` block of code that will add some extra code when the `@route53` variable is `true`.  The `@route53` variable controls whether or not route53 logic is added to final generated CloudFormation template.  Let's move onto the template configuration to see how to set the @route53 variable.

<a id="prev" class="btn btn-basic" href="">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorial-template-config.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
