---
title: Minimal IAM Policy
categories: extras
nav_order: 79
---

The IAM user you use to run the [lono cfn deploy](/reference/lono-cfn-deploy/) command needs a minimal set of IAM policies in order to deploy. Here is a table of the baseline services needed:

Service | Description
--- | ---
CloudFormation | To create the CloudFormation stacks that then creates the the AWS resources that your creates.
S3 | To create the lono managed s3 bucket. Lono uploads the generated CloudFormation template here. [App Files]({% link _docs/extras/app-files.md %}) are also uploaded here.

However, it really depends on what your CloudFormation templates provision. If your templates provision an ec2 instance like the demo blueprint then you'd need EC2 also.

## Instructions

It is recommended that you create an IAM group and associate it with the IAM users that need access to use [lono cfn deploy](/reference/lono-cfn-deploy/).  Here are starter instructions and a policy that you can tailor for your needs:

### Commands Summary

Here's a summary of the commands:

    aws iam create-group --group-name Lono
    cat << 'EOF' > /tmp/lono-iam-policy.json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "cloudformation:*",
                    "ec2:*",
                    "s3:*"
                 ],
                "Resource": [
                    "*"
                ]
            }
        ]
    }
    EOF
    aws iam put-group-policy --group-name Lono --policy-name LonoPolicy --policy-document file:///tmp/lono-iam-policy.json

Finally, create a user and add the user to IAM group. Here's an example:

    aws iam create-user --user-name tung
    aws iam add-user-to-group --user-name tung --group-name Lono

Note, in the example, we're also adding permission for EC2. This demo policy should be enough to launch an EC2 instance in the blueprint that `lono blueprint new demo` generates.

{% include prev_next.md %}
