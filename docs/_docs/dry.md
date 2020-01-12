---
title: 'DRY: Reusable Code'
nav_order: 5
---

Lono is designed to allow you to reuse CloudFormation templates.  A key is the separation of configs and template code in a structured and organized way.

## Configs

Here's an example configs structure:

    configs
    ├── ec2
    │   └── params
    │       ├── development.txt
    │       └── production.txt
    └── vpc
        └── params
            ├── development.txt
            └── production.txt

Notice how there are different `development` and `production` config files. This structure allows you to use different values for different environments for the same CloudFormation template.  Learn more: [Configs docs]({% link _docs/core/configs.md %}).

## Blueprints

The CloudFormation code itself lives in the blueprints folder.

    blueprints
    ├── ec2
    └── vpc

Additionally, blueprints can also be gems.  Example:

```ruby
gem "ec2", git: "git@github.com:boltopspro/ec2"
gem "vpc", git: "git@github.com:boltopspro/vpc"
```

Interestingly, this means the blueprints folder could be empty. You can just use pre-built blueprint gems. [BoltOps Pro blueprints](https://github.com/boltopspro-docs) are actually gems. All you have to do is configure them.

Learn more: [Blueprint docs]({% link _docs/core/blueprints.md %}).

## Summary

With this structure, it DRYs up your code by allowing you to reuse the same CloudFormation templates.  You simply:

1. Configure
2. Deploy
3. Run

{% include prev_next.md %}
