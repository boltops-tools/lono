---
title: Use Existing Templates
nav_order: 2
---

If you already have existing CloudFormation templates, you can use the `--source` option to reuse them.  This allows you to take advantage of lono features. The source can be a file or an url.

## Example

Use [lono new](/reference/lono-new/) to quickly generate an empty lono project.

    lono new infra
    cd infra

Now that we're are in a lono project. Let's use lono with the `--source` option with an existing template. We'll use a [template that creates an EC2 instance](https://raw.githubusercontent.com/tongueroo/cloudformation-ec2-example/5c2f593/ec2.yml).

    $ URL=https://raw.githubusercontent.com/tongueroo/cloudformation-ec2-example/5c2f593/ec2.yml
    $ lono summary demo --source $URL
    => CloudFormation Template Summary for template demo:
    # Parameters Total (2)
    # InstanceType=t3.micro #
    KeyName= # (required)
    # Resources:
      1 AWS::EC2::Instance
      1 AWS::EC2::SecurityGroup
      2 Total
    $

The summary tells us that the template will create an EC2 Instance and a Security group. It also shows that there's a required `KeyName` parameter. Next, let's create the params file with [lono seed](/reference/lono-seed/)

    $ lono seed demo --source $URL
    Creating starter config files for demo
          create  configs/demo/params/development.txt
    $

Let's take a look at the contents of the generated params file.

configs/demo/params/development.txt:

    # InstanceType=t3.micro
    KeyName= # (required)

Set a KeyPair that exists on your AWS account. You can use [aws ec2 describe-key-pairs](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-key-pairs.html) to list the KeyPairs on your account.

    # InstanceType=t3.micro
    KeyName=my-key-pair # must exist on your AWS account

After you set the `KeyName` in the params file, you're ready to launch the CloudFormation stack that creates the EC2 instance.

## Deploy Stack

Deploy the stack with [lono deploy](/reference/lono-cfn-deploy/)

    $ lono cfn deploy demo --source $URL
    ...
    Creating demo stack.
    Waiting for stack to complete
    11:12:00PM CREATE_IN_PROGRESS AWS::CloudFormation::Stack demo User Initiated
    11:12:04PM CREATE_IN_PROGRESS AWS::EC2::SecurityGroup InstanceSecurityGroup
    11:12:08PM CREATE_IN_PROGRESS AWS::EC2::SecurityGroup InstanceSecurityGroup Resource creation Initiated
    11:12:09PM CREATE_COMPLETE AWS::EC2::SecurityGroup InstanceSecurityGroup
    11:12:11PM CREATE_IN_PROGRESS AWS::EC2::Instance EC2Instance
    11:12:13PM CREATE_IN_PROGRESS AWS::EC2::Instance EC2Instance Resource creation Initiated
    11:13:05PM CREATE_COMPLETE AWS::EC2::Instance EC2Instance
    11:13:06PM CREATE_COMPLETE AWS::CloudFormation::Stack demo
    Stack success status: CREATE_COMPLETE
    Time took for stack deployment: 1m 10s.
    $

## Preview Stack

When deploying an updated template, lono will show previews of changes about to deploy. This provides you a lot of useful information before hitting the "big red button".  Lono provides 3 different previews. To demonstrate them, here's a summary of what we'll do:

1. Change the `InstanceType` parameter in `configs/demo/params/development.txt`.
2. Use an update template url with a modified template. To keep things simple, here's the [url with the updated template](https://raw.githubusercontent.com/tongueroo/cloudformation-ec2-example/a505e92/ec2.yml). The `Monitoring: true` property has been added to the EC2 Instance.
3. Use the [lono cfn preview](/reference/lono-cfn-preview/) command to see a preview.
4. Deploy again.

Let's update `InstanceType=t3.small` in configs/demo/params/development.txt:

    InstanceType=t3.small
    KeyName=my-key-pair # must exist on your AWS account

Now we're ready to change the URL to the updated template and preview the changes.

```diff
$ URL=https://raw.githubusercontent.com/tongueroo/cloudformation-ec2-example/a505e92/ec2.yml
$ lono cfn preview demo --source $URL
...
Parameter Diff Preview:
Running: colordiff /tmp/lono/params-preview/existing.json /tmp/lono/params-preview/new.json
2c2
<   "InstanceType": "t3.micro",
---
>   "InstanceType": "t3.small",
Code Diff Preview:
56a57
>       Monitoring: true
Changeset Preview:
CloudFormation preview for 'demo' stack update. Changes:
Modify AWS::EC2::Instance: Instance i-0ceca7445937eab93
$
```

The 3 preview lono provides are:

1. Parameter diff preview - We can see that the `InstanceType` has been changed from a `t3.micro` to `t3.small`
2. Code diff preview - We can see `Monitoring: true` line has been added to the template
3. Changeset preview: - CloudFormation has detected that the instance will be modified.

Previews allow you to deploy changes to the CloudFormation stack with a higher level of confidence. You can deploy when you are ready:

    lono cfn deploy demo --source $URL --sure

Note, deploying without `--sure` will prompt you with the preview to spare you from remembering to run lono cfn preview separately.

## Configset: Automatically Configure Instances

Using existing templates with the `--source` option gives you access to all sorts of lono features. One interesting feature are [configsets]({% link _docs/configsets.md %}).  Configsets are essentially configuration management. It allows you to configure your EC2 instances automatically.  You can do all sorts of customizations. Some examples of things configsets can do: install packages, create files, run commands, ensure services are running.

Let's add the httpd configset. Add the `httpd` gem to your Gemfile to make the configset available.

```ruby
gem "httpd", git: "https://github.com/boltopspro/httpd"
```

Create a [configs file]({% link _docs/configsets/project.md %}) with the following code to use the configset with the demo blueprint:

configs/demo/configsets/base.rb:

```ruby
configset("httpd", resource: "Instance")
```

With that one line of configuration alone, you will install, configure, and run the httpd or apache2 web server. Deploy when you are ready.

    lono cfn deploy demo --source $URL

You will see that lono adds the configset to the CloudFormation template for you.

Note: The [boltopspro/httpd](https://github.com/boltopspro/httpd) repo is a public [BoltOps Pro](https://www.boltops.com/pro) repo.

## Summary

We went through a few lono commands with an existing template. If you have existing templates that you would like to use, the `--source` option provides an excellent way to get started.

We have hardly scratched the surface of lono. There are many more lono features that make working with CloudFormation easier.

* [The Lono DSL]({% link _docs/dsl.md %}) - Generate templates from beautiful code.
* [Variables]({% link _docs/configs/shared-variables.md %}) - Allows you to construct templates at compile-time where runtime Parameters do not suffice.
* [Layering]({% link _docs/core/layering.md %}) - Allows you to build multiple environments like development and production.
* [Helpers support]({% link _docs/core/helpers.md %}) - Allow you to extend Lono and simplify code further.

## Tip

To avoid having to specify `--source` repeatedly, you can import the template.

    lono code import $URL --blueprint demo

Then your commands become simply:

    lono code deploy demo

{% include prev_next.md %}
