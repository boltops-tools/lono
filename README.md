<div align="center">
  <img src="http://lono.cloud/img/logos/lono-logo-small.png" />
</div>

# Lono

[![Gem Version](https://badge.fury.io/rb/lono.png)](http://badge.fury.io/rb/lono)
[![CircleCI](https://circleci.com/gh/tongueroo/lono.svg?style=svg)](https://circleci.com/gh/tongueroo/lono)
[![Code Climate][3]][4]
[![Dependency Status](https://gemnasium.com/tongueroo/lono.png)](https://gemnasium.com/tongueroo/lono)
[![Coverage Status](https://coveralls.io/repos/tongueroo/lono/badge.png)](https://coveralls.io/r/tongueroo/lono)
[![Join the chat at https://gitter.im/tongueroo/lono](https://badges.gitter.im/tongueroo/lono.svg)](https://gitter.im/tongueroo/lono?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Support](https://img.shields.io/badge/get-support-blue.svg)](https://boltops.com?utm_source=badge&utm_medium=badge&utm_campaign=lono)

[3]: https://codeclimate.com/repos/51d7f1407e00a4042c010ab4/badges/5273fe6cdb5a13e58554/gpa.png
[4]: https://codeclimate.com/repos/51d7f1407e00a4042c010ab4/feed

Lono is a tool to help you manage your CloudFormation templates. Lono handles the entire CloudFormation lifecyle. It helps you craft the templates and then provisions of the infrastructure.

* Lono generates CloudFormation templates based on ERB ruby templates in `yaml` format.
* Lono takes simple env-like files and generates the CloudFormation parameter files.
* Lono provides a simple CLI interface to launch the CloudFormation stacks.

See [lono.cloud](http://lono.cloud) for full lono documentation.

## Important

If you are on version 3, you can run `lono upgrade4` within your project to upgrade it to version 4.  Refer to the [CHANGELOG](CHANGELOG.md).

## Blog Posts

These blog posts also cover lono:

* [Why Generate CloudFormation Templates with Lono](https://medium.com/boltops/why-generate-cloudformation-templates-with-lono-65b8ea5eb87d)
* [Generating CloudFormation Templates with Lono](https://medium.com/boltops/generating-cloudformation-templates-with-lono-4709afa1299b)
* [AutoScaling CloudFormation Template with Lono](https://medium.com/boltops/autoscaling-cloudformation-template-with-lono-3dc520480c5f)
* [CloudFormation Tools: lono, lono-params and lono cfn Together](https://medium.com/boltops/cloudformation-tools-lono-lono-params-and-lono-cfn-play-together-620af51e616)
* [AWS CloudFormation dry-run with lono cfn preview](https://medium.com/boltops/aws-cloudformation-dry-run-with-lono-cfn-plan-2a1e0f80d13c)

## Quick Usage

It only takes a couple of commands to start using lono.

```sh
gem install lono
lono new infra
cd infra
lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/EC2InstanceWithSecurityGroupSample.template --name ec2
# update the generated params file
lono cfn create ec2
```
![Lono flowchart](http://tongueroo.com/images/github-readmes/lono-flowchart.png "Lono flowchart")

### Lono Cfn Lifecycle Commands

Lono provides a `lono cfn` lifecycle command that allows you to launch stacks quickly.  The `lono cfn` tool automatically runs `lono generate` internally and then launches the CloudFormation stack all in one command.  If you are in a lono project and have a `my-stack` lono template definition.  To create a stack you can simply run:

```
$ lono cfn create my-stack
```

The above command will generate files to `output/templates/my-stack.json` and `output/params/my-stack.txt` and use them to create a CloudFormation stack.  Here are some more examples of cfn commands:

```
$ lono cfn create mystack-$(date +%Y%m%d%H%M%S) --template mystack --params mystack
$ lono cfn create mystack-$(date +%Y%m%d%H%M%S) # shorthand if template and params file matches.
$ lono cfn diff mystack-1493859659
$ lono cfn preview mystack-1493859659
$ lono cfn update mystack-1493859659
$ lono cfn delete mystack-1493859659
$ lono cfn create -h # getting help
```

See [lono.cloud](http://lono.cloud) for full lono documentation.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Developing

There is a submodule in this project, so when you check out remember to sync the submodule.

```bash
$ git clone git@github.com:yourfork/lono.git
$ git submodule sync
$ git submodule update --init
```
