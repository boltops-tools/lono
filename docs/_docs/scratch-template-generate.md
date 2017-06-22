---
title: Generate the Template
---

With the `config/lono.rb` and `templates/instance.yml.erb` in place, we are ready to generate the CloudFormation templates.  Run the following command:

```sh
lono generate
```

You should see similar output:

```
$ lono generate
Generating both CloudFormation template and parameter files.
Generating CloudFormation templates:
  output/single_instance.yml
  output/instance_and_route53.yml
Generating params files
$
```

The `lono generate` command combines the configuration from `config/lono.rb` and template from `templates/instance.yml.erb` and generates 2 CloudFormation templates in the `output` folder.

Here's the `templates/instance.yml.erb` ERB template. Note that some of the source code has been shorten for brevity.

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
```

Here's the `config/lono.rb` configuration:

```ruby
template "single_instance.yml" do
  source "instance.yml.erb"
end

template "instance_and_route53.yml" do
  source "instance.yml.erb"
  variables(
    route53: true
  )
end
```

And here is one of the output templates `output/instance_and_route53.yml`. Note that some of the source code has been shorten for brevity.

```yaml
---
AWSTemplateFormatVersion: '2010-09-09'
Description: 'AWS CloudFormation Sample Template EC2InstanceWithSecurityGroupSample:
Parameters:
  KeyName:
    Description: Name of an existing EC2 KeyPair to enable SSH access to the instance
    Type: AWS::EC2::KeyPair::KeyName
    ConstraintDescription: must be the name of an existing EC2 KeyPair.
Resources:
  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType:
        Ref: InstanceType
...
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
...
```

You can use the generated CloudFormation templates in the `output` folder just as you would a normal CloudFormation template.  Here's a flow chart of the overall process.

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

Let's also compare the generated `instance_with_route53.yml` and `single_instance.yml` CloudFormation templates files in the output folder.  You will notice that the route53 logic is only one of the files.  A quick way to see this is with th `diff` or `colordiff` command.

```
$ diff output/single_instance.yml output/instance_and_route53.yml
85a86,91
>   HostedZoneName:
>     Description: The route53 HostedZoneName. For example, "mydomain.com."  Don't forget the period at the end.
>     Type: String
>   Subdomain:
>     Description: The subdomain of the dns entry. For example, hello -> hello.mydomain.com, hello is the subdomain.
>     Type: String
389a396,405
>   DnsRecord:
>     Type: AWS::Route53::RecordSet
>     Properties:
>       HostedZoneName: !Ref 'HostedZoneName'
>       Comment: DNS name for my instance.
>       Name: !Join ['', [!Ref 'Subdomain', ., !Ref 'HostedZoneName']]
>       Type: CNAME
>       TTL: '900'
>       ResourceRecords:
>       - !GetAtt EC2Instance.PublicIp
$
```

Next we'lll move onto specifying the parameters to be use for lauching the CloudFormation stack.

<a id="prev" class="btn btn-basic" href="/docs/scratch-template-config/">Back</a>
<a id="next" class="btn btn-primary" href="/docs/scratch-params-build/">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

