---
title: "Tutorial: Edit Template"
---

The current AutoScaling template contains a Load Balancer and AutoScaling.  It is designed for web applications.  Let's say we still wanted AutoScaling but do not need the Load Balancer.  An common example of this use case is an AutoScaling  worker or queue tier.  We can achieve this in several ways.

### Lono Phases Review

First, let's review the lono phases:

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

Lono introduces a Compile phase where it takes the `app/templates` files, uses ERB variables, and produces different templates in the `output/templates` folder.

We'll show you 2 approaches so you can get a sense, learn, and decide when you want to use one approach over the other. The 2 approaches:

1. Compiling Different Templates with Lono
2. Using Standard CloudFormation Logical Constructs

### Compiling Different Templates Approach

This is pretty straightforward to do with lono templates.  The source code for these changes are in the lono-constructs branch of [lono-tutorial-autoscaling](https://github.com/tongueroo/lono-tutorial-autoscaling/blob/standard-constructs/app/templates/autoscaling.yml).  Let's take a look at the relevant [changes](https://github.com/tongueroo/lono-tutorial-autoscaling/compare/lono-constructs).

We changed the `app/definitions/base.rb` to:

```ruby
template "autoscaling-web" do
  source("autoscaling")
  variables(load_balancer: true)
end
template "autoscaling-worker" do
  source("autoscaling")
  variables(load_balancer: false)
end
```

Then we added `<% if @load_balancer %>` checks to the sections of the template where we want to turn on and off the load balancer.  The template is large so here is a link to the [autoscaling.yml code](https://github.com/tongueroo/lono-tutorial-autoscaling/blob/lono-constructs/app/templates/autoscaling.yml) and the [compare view](https://github.com/tongueroo/lono-tutorial-autoscaling/compare/lono-constructs) that adds this adjustment.

#### Lono Generate

Then, it is helpful to generate the templates and verify that the generated templates `output/templates` are what we expect before launching.

```
$ lono generate
Generating CloudFormation templates, parameters, and scripts
No detected app/scripts
Generating CloudFormation templates:
  output/templates/autoscaling-web.yml
  output/templates/autoscaling-worker.yml
Generating parameter files:
  output/params/autoscaling.json
$
```

You can also use `lono summary` to see that the resources are different. Here's the output of `lono summary` with the parameters info filtered out:

```
$ lono summary autoscaling-web
=> CloudFormation Template Summary:
...
Resources:
  2 AWS::AutoScaling::ScalingPolicy
  2 AWS::CloudWatch::Alarm
  1 AWS::AutoScaling::LaunchConfiguration
  1 AWS::ElasticLoadBalancingV2::LoadBalancer
  1 AWS::ElasticLoadBalancingV2::Listener
  1 AWS::ElasticLoadBalancingV2::TargetGroup
  1 AWS::SNS::Topic
  1 AWS::EC2::SecurityGroup
  1 AWS::AutoScaling::AutoScalingGroup
  9 Total
$ lono summary autoscaling-worker
=> CloudFormation Template Summary:
...
Resources:
  2 AWS::AutoScaling::ScalingPolicy
  2 AWS::CloudWatch::Alarm
  1 AWS::SNS::Topic
  1 AWS::AutoScaling::AutoScalingGroup
  1 AWS::AutoScaling::LaunchConfiguration
  1 AWS::EC2::SecurityGroup
  6 Total
$
```

We can see that `autoscaling-web` has 9 resources and `autoscaling-worker` has 6 resources.

#### Launch Stacks

When things look good, launch both stacks:

```
lono cfn create autoscaling-web --param autoscaling
lono cfn create autoscaling-worker --param autoscaling
```

You should see a total of 3 stacks now. Something like this:

<img src="/img/tutorial/autoscaling-both-stacks.png" alt="Stack Created" class="doc-photo lono-flowchart">

Note, we're using the same `output/params/autoscaling.json` param file from the original template by specifying the `--param autoscaling` option.  Another way to is to make a copy of the params file for each template like so:

```
cp config/params/base/autoscaling{,-web}.txt
cp config/params/base/autoscaling{,-worker}.txt
```

Then you can edit the files and adjust the new parameters to what you want.  As an added benefit of using parameter files with matching names as their template output names, the `lono cfn create` commands become simple again:

```
lono cfn create autoscaling-web
lono cfn create autoscaling-worker
```

This is due to conventions that lono uses. If no param option is provided, then the convention is for the param file to default to the name of the template option. The conventions covered in detailed in [Conventions]({% link _docs/conventions.md %}).

### Standard CloudFormation Logical Constructs Approach

Using standard CloudFormation logical constructs is a little bit different but just as valid of an appraoch. Sometimes it is preferable over compiling different templates; it just depends.  Here are the changes required to make the desired adjustments: [compare/standard-constructs](https://github.com/tongueroo/lono-tutorial-autoscaling/compare/standard-constructs).  Note, UserData and the UpdatePolicy was to removed for the sake of this guide and to focus on learning.

The important added element that drives the conditional logic is a parameter and 2 conditions.  The parameter is called `CreateLoadBalancer` and the conditions are called `HasLoadBalancer` and `NoLoadBalancer`. Here's the relevant snippet of code:


```yaml
Parameters
...
  CreateLoadBalancer:
    Type: String
    Description: 'Determines if a Load Balancer is created. Example: true or false'
Conditions:
  HasLoadBalancer: !Equals [ !Ref CreateLoadBalancer, "true" ]
  NoLoadBalancer: !Equals [ !Ref CreateLoadBalancer, "false" ]
```

The rest of the the template uses these 2 new conditions to determine whether or not to create a Load Balancer.  For Properties, the use of the conditions look something like this:

Before:

```yaml
     Properties:
       SecurityGroups:
      - Ref: InstanceSecurityGroup
```

After:

```yaml
     Properties:
       SecurityGroups:
      - !If [HasLoadBalancer, !Ref WebInstanceSecurityGroup, !Ref WorkerInstanceSecurityGroup]
```

For template resources, we usually have to define 2 resources and then toggle between them with the conditions like so:

Before:

```yaml
  InstanceSecurityGroup:
    Type: AWS::EC2::SecurityGroup
```

After:

```yaml
  WebInstanceSecurityGroup:
    Condition: HasLoadBalancer
    Type: AWS::EC2::SecurityGroup
    ...
  WorkerInstanceSecurityGroup:
    Condition: NoLoadBalancer
    Type: AWS::EC2::SecurityGroup
    ...
```

For the sake of this guide, feel free to grab `app/templates/autoscaling` from the [standard-constructs](https://github.com/tongueroo/lono-tutorial-autoscaling/blob/standard-constructs/app/templates/autoscaling.yml) branch and update the code.

#### Launch Stack

Let's launch both stacks:

```
lono cfn create autoscaling-web --template autoscaling --param autoscaling-web
lono cfn create autoscaling-worker --template autoscaling --param autoscaling-worker
```

In this case we need to specify both `--template` and `--param` options since it breaks away from lono conventions.  We have successfully launched stacks again!  This time with standard CloudFormation constructs.

### Thoughts

We have successfully edited existing CloudFormation templates and taken 2 approaches to adding conditional logic:

1. Compiling Different Templates with Lono
2. Using Standard CloudFormation Logical Constructs

A major difference is when the conditional logic gets determined. When we use standard CloudFormation constructs, the logical decisions get made at **run-time**. When we use lono to produce multiple templates it happens at **compile time**.  Whether this is good or bad is really up to how you use it. Remember, "With great power comes great responsibility."
