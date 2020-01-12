---
title: Lono Stack and Bucket
categories: extras
nav_order: 78
---

## Overview

There's a lono stack that was created. What is the purpose of the `lono` stack?

The lono stack is an additional stack that lono creates. The stack creates an s3 bucket that is managed by lono. It spares you the need from creating the s3 bucket manually.

The bucket is used to upload the generated CloudFormation templates as part of a [lono cfn deploy](/reference/lono-cfn-deploy/).  This allows you to have larger template sizes.  See [AWS CloudFormation Limits](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-limits.html).  Lono also uses the bucket to store [App Files]({% link _docs/extras/app-files.md %}).

The stack and bucket lives outside your CloudFormation templates in its own standalone stack so it can be reused by other lono CloudFormation stacks.  Hence the lono stack should be left alone.  [Termination Protection](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-protect-stacks.html) is enabled on the lono CloudFormation stack by default for safety.

## Deleting the lono stack and bucket

To delete the lono stack, you must:

1. Disable Termination Protection
2. Empty the S3 bucket
3. Delete the Stack

For convenience, you can also use the `lono s3 delete` command to perform all of these steps.

{% include prev_next.md %}
