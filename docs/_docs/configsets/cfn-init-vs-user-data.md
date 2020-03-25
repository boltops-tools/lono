---
title: cfn-init vs user-data
nav_text: cfn-init vs user-data
categories: configsets
order: 13
nav_order: 79
---

### What's the difference between using the cfn-init the UserData script?

Both approaches provide ways to bootstrap, configure, and install things on an EC2 Instance.

A key difference between the two approaches is that UserData will replace the EC2 instance entirely, whereas cfn-init will do an [in-place update](https://stackoverflow.com/questions/35095950/what-are-the-benefits-of-cfn-init-over-userdata).

Using configsets provide the benefit of not fully replacing the EC2 instance. This allows you to deploy new changes incrementally.  The bootstrap script will not start from scratch on a brand new instance, reinstalling everything.

Using configsets over UserData also reduces the amount of pollution in the UserData script.

Note: If you are using cfn-init with AutoScaling, CloudFormation will only replace the instance if you have a [UpdatePolicy AutoScalingRollingUpdate](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-updatepolicy.html#aws-attribute-updatepolicy-examples) configured. If you do not, then the EC2 instance will not be updated. In that case, You must manually terminate the instance, and AutoScaling will it the instance.

### Are configsets reusable?

Normally, with CloudFormation, configs from [AWS::CloudFormation::Init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html) are not [reusable](https://stackoverflow.com/questions/27499509/reusing-awscloudformationinit-and-userdata-for-multiple-instances). However, lono allows them to be reusable since lono injects them into the template down as part of deployment. More details: [Lono Configsets]({% link _docs/configsets/reusable.md %})

{% include prev_next.md %}
