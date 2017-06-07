---
title: Build the Template
---

#### Download the Template

Let's build the CloudFormation template.  Copy and paste this [starter CloudFormation template](https://github.com/tongueroo/cloudformation-examples-lono/blob/master/templates/instance.yml.erb) into `templates/instance.yml.erb`.  Or you can simply use `wget` to download the file:

```sh
wget https://raw.githubusercontent.com/tongueroo/cloudformation-examples-lono/master/templates/instance.yml.erb
mv instance.yml.erb templates/instance.yml.erb
```

#### ERB Template vs CloudFormation Template

The starter template that was created above is more powerful than a standard CloudFormation template.  It is an ERB template which means it can contain loops, if statements and variables. Here is a good post covering ERB templates [An Introduction to ERB Templating](http://www.stuartellis.name/articles/erb/).

Let's take a look at some of the variables in our template.  Variables available in the templates are indicated by a '@' character.  We can get a quick overview of them by searching for them with grep.

```sh
$ grep '@' templates/instance.yml.erb
<% if @route53 %>
<% if @route53 %>
```

There are 2 `@route53` variables in the `templates/instance.yml.erb`.  Let's provide a little context around the grep to get better feel of their purpose.

```diff
$ grep -5 '@' templates/instance.yml.erb
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

So in this downloaded template, there's an `<% if @route53 %>` block of code that will added some extra code if the `@route53` variable is `true`.  The `@route53` variable controls whether or not route53 logic is added to final generated CloudFormation template.  Let's move on the template configuration to see how to configure the @route53 variable.

<a class="btn btn-basic" href="{% link _docs/scratch.md %}">Back</a>
<a class="btn btn-primary" href="{% link _docs/scratch-template-config.md %}">Next Step</a>
