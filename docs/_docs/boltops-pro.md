---
title: What is BoltOps Pro?
nav_order: 10
---

[BoltOps Pro](https://www.boltops.com/pro) is Infrastructure Code as a Service. BoltOps Pro provides reusable CloudFormation templates.  The templates are tested in a daily build process. They are completely configurable to fit your needs. Essentially, they save you time.

You can also see the list of available Pro blueprints with the [lono pro blueprints]({% link _reference/lono-pro-blueprints.md %}) command.

    $ lono pro blueprints
    +-------------------+------------------------------------------------------+-----------------------------------------+
    |       Name        |                      Docs                            |               Description               |
    +-------------------+------------------------------------------------------+-----------------------------------------+
    | aurora            | https://github.com/boltopspro-docs/aurora            | RDS Aurora Database Blueprint           |
    | aurora-serverless | https://github.com/boltopspro-docs/aurora-serverless | RDS Aurora Serverless Database          |
    | bastion           | https://github.com/boltopspro-docs/bastion           | Bastion jumpbox                         |
    | cloudfront        | https://github.com/boltopspro-docs/cloudfront        | CloudFront Blueprint                    |
    | ec2               | https://github.com/boltopspro-docs/ec2               | EC2 Instance Blueprint                  |
    | ecs-asg           | https://github.com/boltopspro-docs/ecs-asg           | ECS AutoScaling Blueprint               |
    | ecs-spot          | https://github.com/boltopspro-docs/ecs-spot          | ECS Spot Blueprint                      |
    | elasticache       | https://github.com/boltopspro-docs/elasticache       | Amazon Elasticache Memcached and Red... |
    | elb               | https://github.com/boltopspro-docs/elb               | ELB Blueprint: Application or Networ... |
    | rds               | https://github.com/boltopspro-docs/rds               | RDS Database Blueprint                  |
    | sns               | https://github.com/boltopspro-docs/sns               | SNS Topic Blueprint                     |
    | vpc               | https://github.com/boltopspro-docs/vpc               | VPC blueprint: Create Reference Arch... |
    | vpc-peer          | https://github.com/boltopspro-docs/vpc-peer          | Peer VPCs across multiple accounts b... |
    | vpc-peer-one      | https://github.com/boltopspro-docs/vpc-peer-one      | VPC Peering Blueprint: Peer VPCs wit... |
    +-------------------+------------------------------------------------------+-----------------------------------------+
    $

A list of the blueprint docs is also publicly available at: [boltopspro-docs](https://github.com/boltopspro-docs).  Access to the [boltops private repos](https://github.com/boltopspro) is only available to [BoltOps Pro subscribers](https://www.boltops.com/pro). BoltOps Pro also gives you access to all the boltopspro repos.

## Configsets

The BoltOps Pro also include access to [Pro Configsets repos](https://github.com/search?q=topic%3Alono-configset+org%3Aboltopspro-docs&type=Repositories).  [Configsets]({% link _docs/configsets.md %}) are essentially configuration management.  Use configsets to configure and update your EC2 instances automatically.  Some examples of things configsets can do: install packages, create files, create users, download files, run commands, ensure services are running.

You can also see the list of available Pro configsets with the [lono pro configsets]({% link _reference/lono-pro-configsets.md %}) command.

    $ lono pro configsets
    +---------------------+--------------------------------------------------------+-----------------------------------------+
    |        Name         |                          Docs                          |               Description               |
    +---------------------+--------------------------------------------------------+-----------------------------------------+
    | amazon-linux-extras | https://github.com/boltopspro-docs/amazon-linux-extras | amazon-linux-extras                     |
    | awslogs             | https://github.com/boltopspro-docs/awslogs             | awslogs configset: installs, configu... |
    | cfn-hup             | https://github.com/boltopspro-docs/cfn-hup             | cfn-hup configset: configures and en... |
    | golang              | https://github.com/boltopspro-docs/golang              | golang configset: install go program... |
    | httpd               | https://github.com/boltopspro-docs/httpd               | httpd configset: install, configure,... |
    | ruby                | https://github.com/boltopspro-docs/ruby                | ruby configset: install ruby on amaz... |
    | ssm                 | https://github.com/boltopspro-docs/ssm                 | SSM Configset: Install, Configure an... |
    | toolset             | https://github.com/boltopspro-docs/toolset             | toolset configset: install common li... |
    +---------------------+--------------------------------------------------------+-----------------------------------------+
    $

{% include prev_next.md %}
