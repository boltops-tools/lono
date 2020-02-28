---
title: cfn-init vs cloud-init
nav_text: cfn-init vs cloud-init
categories: configsets
order: 12
nav_order: 69
---

There are two similarly named projects: cfn-init and cloud-init. Both provide a standard way to customize EC2 instances, but they are different tools. You may be wondering what's the difference between these projects.

* cloud-init is a Ubuntu-developed project that provides a standard to customize Cloud instances.
* cfn-init is an AWS supported way of customizing EC2 instances.

## More Details

### cloud-init

The [cloud-init](https://cloud-init.io/) project tagline is that they are "The standard for customising cloud instances". So it works with multiple cloud providers. It comes pre-installed in the Ubuntu Cloud Images and also on the official EC2 Ubuntu images. It has a larger documentation site: [cloud-init Documentation](https://cloudinit.readthedocs.io/en/latest/).

The Cloud configs are written as YAML and allow you to use directives for common tasks like installing packages, configuring files, and running commands.  Here are [Cloud config examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html) Interestingly, there does not seem to be a service module.

The cloud-init scripts are stored in UserData in [multipart format](https://cloudinit.readthedocs.io/en/latest/topics/format.html#). They get expanded out to the [/var/lib/cloud directory](https://cloudinit.readthedocs.io/en/latest/topics/dir_layout.html) and then ran.

### cfn-init

The cfn-init tool is an AWS officially supported way of customizing EC2 instances.  It has simpler documentation. In fact there are really 2 main pages: [AWS::CloudFormation::Init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html) and [cfn-init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-init.html).  It supports common configuration management tasks like creating packages, groups, users, sources, files, commands, services.  These tasks are group together in "Configset".  Configsets are a part of a CloudFormation template, so they can be written as YAML or JSON.

The cfn-init script is pre-installed on the AmazonLinux2 distro. AWS packaged it up to make it easier to customize EC2 instances without having to take the additional step of installing a configuration management tool.

The cfn-init script typically pulls the Configset definition from the CloudFormation stack template itself.  It can also be provided a JSON Configset definition directly from the file system.

{% include prev_next.md %}
