---
title: "Tutorial EC2: Edit Template Natively"
---

### Native CloudFormation Logical Constructs Approach

In the last section, we added conditional logical to create or not create an EIP using lono. In this section, we'll use native CloudFormation constructs. Hopefully, this gives you a sense of the differences between the 2 approaches.

Using native CloudFormation logical constructs is a little bit different but is just as valid of an approach. Sometimes it is preferable over compiling different templates; it just depends.  Here are the changes required to make the desired adjustments: [compare/eip-native](https://github.com/tongueroo/lono-tutorial-ec2/compare/eip-native).

The critical added element that drives the conditional logic is a parameter and 2 conditions.  The parameter is called `CreateEIP` and the conditions are called `HasEIP` and `NoEIP`. Here's the relevant snippet of code:


```yaml
Parameters
...
  CreateEIP:
    Type: String
    Description: Determines whether or not to create an EIP address
Conditions:
  HasEIP: !Equals [ !Ref CreateEIP, "true" ]
  NoEIP: !Equals [ !Ref CreateEIP, "false" ]
```

The rest of the template uses these 2 new conditions to determine whether or not to create a Load Balancer.  For Properties, the use of the conditions look something like this:

```yaml
  IPAddress:
    Condition: HasEIP
    Type: AWS::EC2::EIP
  IPAssoc:
    Condition: HasEIP
    Type: AWS::EC2::EIPAssociation
    Properties:
      InstanceId:
        Ref: EC2Instance
      EIP:
        Ref: IPAddress
```

Sometimes for template resources, we have to define 2 resources and then toggle between them with the conditions, but this the case of this simple template we do not have to use that technique.

For the sake of this guide, feel free to grab `app/templates/ec2.yml` from the [eip-native](https://github.com/tongueroo/lono-tutorial-ec2/blob/eip-native/app/templates/ec2.yml) branch and update the code.

#### Launch Stack

After they have completed deletion, we're ready to relaunch both stacks:

```
lono cfn create ec2
lono cfn create eip --template ec2 --param eip
```

For the the `eip` stack, we need to specify both `--template` and `--param` options since it breaks away from lono conventions.

We have successfully relaunched stacks!  This time with native CloudFormation constructs.  Remember to clean up and delete the stacks again.

```
lono cfn delete ec2
lono cfn delete eip
```

### Thoughts

We have successfully edited existing CloudFormation templates and taken 2 approaches to adding conditional logic:

1. Compiling Different Templates with Lono
2. Using Native CloudFormation Logical Constructs

A major difference is when the conditional logic gets determined. When we use standard CloudFormation constructs, the logical decisions get made at **run-time**. When we use lono to produce multiple templates it happens at **compile time**.  Whether this is good or bad is really up to how you use it. Remember, "With great power comes great responsibility."
