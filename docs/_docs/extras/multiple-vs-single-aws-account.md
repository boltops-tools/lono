---
title: Multiple vs Single Accounts
categories: extras
nav_order: 80
---

There are 2 strategies for deploying your environments on AWS that are worth discussing.

1. Multiple AWS Accounts
2. Single AWS Account

## Mutiple AWS Accounts

In multiple-account approach, each environment is deployed to a separate AWS account. For example production, management, and development are all on completely separate AWS accounts.

The multiple-account strategy is commonly used today because of the benefits.  You get complete isolation between the environments. You have nice guardrail against accidentally doing something on production that was meant for development.

Additionally, AWS supports many features that make using multiple-account much easier today.  [AWS Organizations](https://aws.amazon.com/organizations/) help you centrally create, manage, and organize multiple AWS accounts from a parent master account.  Also, the aws cli and AWS sdk support switching AWS accounts with [Named Profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) and the `AWS_PROFILE` env var.  The AWS Console brower experience also supports switching between accounts easily.

The main drawbrack with the multiple-account is that you have to remember to switch accounts.

Overall, the multiple-account approach is the recommended approach.

## Single AWS Account

In a single-account approach, each environment like production and development is deployed to the same AWS account.

The benefit is that you don't have to remember to switch `AWS_PROFILE`.

The drawbracks is less isolation between the environments. You must be more careful to achieve isolation with AWS features like IAM policies, security groups, etc.

## Lono Flexibility

Lono easily supports either approach. Lono even has an [aws_profile setting](https://lono.cloud/docs/configuration/settings/) so you don't forget to also set `LONO_ENV` when switching between AWS accounts.  Example:

configs/settings.yml:

```ruby
development:
  aws_profile: dev_profile

production:
  aws_profile: prod_profile
```

When switch `AWS_PROFILE=prod_profile`, then `LONO_ENV=production` will also automatically be applied. By configuring the `configs/settings.yml`, you don't have to remember to specify it.

### Multiple Accounts Example

In a multiple-accounts setup, commands become very short and pretty.

    export AWS_PROFILE=dev_profile
    lono deploy vpc # deploy VPC to development AWS account
    export AWS_PROFILE=prod_profile
    lono deploy vpc # deploy VPC to production AWS account

### Single Account Example

In a single-account setup, the commands become slightly longer. You must specify different stack names. Also, you'll have to remember to specify `LONO_ENV=production` for non-development environments.

    unset LONO_ENV # default is LONO_ENV=development
    lono deploy vpc-development --blueprint vpc
    export LONO_ENV=production
    lono deploy vpc-production  --blueprint vpc

Generally, the multiple-account approach is the recommended approach.

{% include prev_next.md %}
