---
title: "Tutorial EC2: Edit Template"
---

The imported EC2 template contains an EC2 instance and security group.  Let's say we wanted to sometimes associate an EIP address with the EC2 instance but not always.  We can achieve this in several ways.

### Lono Phases Review

First, let's review the lono phases:

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

Lono introduces a Compile phase where it takes the `app/templates` files, uses ERB variables, and produces different templates in the `output/templates` folder.

We'll show you 2 approaches so you can get a sense, learn, and decide when you want to use one approach over the other. The 2 approaches:

1. Compiling Different Templates with Lono
2. Using Native CloudFormation Logical Constructs

### Compiling Different Templates Approach

First, we'll take compiling different templates approach. Compiling different templates is pretty straightforward with lono templates.  The source code for these changes are in the eip branch of [lono-tutorial-ec2](https://github.com/tongueroo/lono-tutorial-ec2/blob/eip/app/templates/ec2.yml).  Let's take a look at the relevant [changes](https://github.com/tongueroo/lono-tutorial-ec2/compare/eip).

We changed the `app/definitions/base.rb`:

Before:

```ruby
template "ec2" do
```

After:

```ruby
template "ec2" do
  source "ec2"
  variables(eip: false)
end
template "eip" do
  source "ec2"
  variables(eip: true)
end
```

The above code tells lono to generate 2 templates at `output/templates/ec2.yml` and `output/templates/eip.yml`. Both templates use the same source template `app/templates/ec2.yml`. However, each one has a different value for the `eip` variable.  The `eip` variable is available in the `app/templates` as `@eip`.

In the source template `app/templates/ec2.yml` we modified it to include a few
`<% if @eip %>` checks at the sections of the template where we want to include EIP related components. Here's a portion of the template as an example:

```
...
  InstanceSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable SSH access via port 22
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: '22'
        ToPort: '22'
        CidrIp:
          Ref: SSHLocation
<% if @eip %>
  IPAddress:
    Type: AWS::EC2::EIP
  IPAssoc:
    Type: AWS::EC2::EIPAssociation
    Properties:
      InstanceId:
        Ref: EC2Instance
      EIP:
        Ref: IPAddress
<% end %>
Outputs:
  InstanceId:
    Description: InstanceId of the newly created EC2 instance
    Value:
      Ref: EC2Instance
...
```

Here's the full template code [ec2.yml code](https://github.com/tongueroo/lono-tutorial-ec2/blob/eip/app/templates/ec2.yml).  You can also see the exact adjustments with the [compare view](https://github.com/tongueroo/lono-tutorial-ec2/compare/eip).

### ERB vs CloudFormation Template

We're are not limited to just if statements.  Since this is ERB, we can use loops, variables, expressions, etc.  Here is a good post covering ERB templates [An Introduction to ERB Templating](http://www.stuartellis.name/articles/erb/). Additionally, we have access to [built-in helpers]({% link _docs/builtin-helpers.md %}) and [shared variables]({% link _docs/shared-variables.md %}).  You can also define your own [custom helpers]({% link _docs/custom-helpers.md %}) if needed.

#### Lono Generate

It is helpful to generate the templates and verify that the files in `output/templates` look like before launching.

```
$ lono generate
Generating CloudFormation templates, parameters, and scripts
No detected app/scripts
Generating CloudFormation templates:
  output/templates/ec2.yml
  output/templates/eip.yml
Generating parameter files:
  output/params/ec2.json
$
```

You can also use `lono summary` to see that the resources are different. Here's the output of `lono summary` with the parameters info filtered out:

```
$ lono summary ec2
Resources:
  1 AWS::EC2::Instance
  1 AWS::EC2::SecurityGroup
  2 Total
$ lono summary eip
Resources:
  1 AWS::EC2::Instance
  1 AWS::EC2::SecurityGroup
  1 AWS::EC2::EIP
  1 AWS::EC2::EIPAssociation
  4 Total
$
```

We can see that `ec2` has 2 resources and `eip` has 4 resources; what we expect.

Another way we can compare the 2 generated templates is by diff-ing them.

```diff
$ diff output/templates/ec2.yml output/templates/eip.yml
394a395,403
>   IPAddress:
>     Type: AWS::EC2::EIP
>   IPAssoc:
>     Type: AWS::EC2::EIPAssociation
>     Properties:
>       InstanceId:
>         Ref: EC2Instance
>       EIP:
>         Ref: IPAddress
406,407c415,416
<   PublicDNS:
<     Description: Public DNSName of the newly created EC2 instance
---
>   InstanceIPAddress:
>     Description: IP address of the newly created EC2 instance
409,417c418
<       Fn::GetAtt:
<       - EC2Instance
<       - PublicDnsName
<   PublicIP:
<     Description: Public IP address of the newly created EC2 instance
<     Value:
<       Fn::GetAtt:
<       - EC2Instance
<       - PublicIp
---
>       Ref: IPAddress
```

#### Launch Stacks

When things look good, launch both stacks:

```
lono cfn create ec2
lono cfn create eip --param ec2
```

You should see the new stacks now. It should look something like this:

<img src="/img/tutorials/ec2/both-stacks.png" alt="Stack Created" class="doc-photo lono-flowchart">

Notice how for the second command needed to specify the `--param eip` option.  We're using the same params for both stacks.  The first command did not require us to specify the param file because lono conventionally defaults the param name to the template name. The conventions are covered in detailed in [Conventions]({% link _docs/conventions.md %}).


#### Clean Up

Let's do a little clean up and delete some of the stacks before continuing with the `lono cfn delete` command:

```
lono cfn delete ec2
lono cfn delete eip
```

#### Congrats
Congraluations 🎉 You have successfully added conditional logic to CloudFormation templates that decides whether or not to create an EIP.
