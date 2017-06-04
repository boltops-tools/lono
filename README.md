# Lono

[![ReadmeCI](http://www.readmeci.com/images/readmeci-badge.svg)](http://www.readmeci.com/tongueroo/lono)
[![Gem Version](https://badge.fury.io/rb/lono.png)](http://badge.fury.io/rb/lono)
[![CircleCI](https://circleci.com/gh/tongueroo/lono.svg?style=svg)](https://circleci.com/gh/tongueroo/lono)
[![Code Climate][3]][4]
[![Dependency Status](https://gemnasium.com/tongueroo/lono.png)](https://gemnasium.com/tongueroo/lono)
[![Coverage Status](https://coveralls.io/repos/tongueroo/lono/badge.png)](https://coveralls.io/r/tongueroo/lono)

[3]: https://codeclimate.com/repos/51d7f1407e00a4042c010ab4/badges/5273fe6cdb5a13e58554/gpa.png
[4]: https://codeclimate.com/repos/51d7f1407e00a4042c010ab4/feed

Lono is a tool for managing CloudFormation templates.

* Lono generates CloudFormation templates based on ERB ruby templates in either `yaml` or `json` format.
* Lono takes simple env-like files to and generates the CloudFormation parameter files.
* Lono wraps the CloudFormation api calls in a simple interface using the generated files to launch the CloudFormation stacks.

These blog posts lono:

* [Why Generate CloudFormation Templates with Lono](https://medium.com/boltops/why-generate-cloudformation-templates-with-lono-65b8ea5eb87d)
* [Generating CloudFormation Templates with Lono](https://medium.com/boltops/generating-cloudformation-templates-with-lono-4709afa1299b)
* [AutoScaling CloudFormation Template with Lono](https://medium.com/boltops/autoscaling-cloudformation-template-with-lono-3dc520480c5f)
* [CloudFormation Tools: lono, lono-params and lono cfn Together](https://medium.com/boltops/cloudformation-tools-lono-lono-params-and-lono-cfn-play-together-620af51e616)
* [AWS CloudFormation dry-run with lono cfn preview](https://medium.com/boltops/aws-cloudformation-dry-run-with-lono-cfn-plan-2a1e0f80d13c)

## Usage

<pre>
$ lono new infra
</pre>

This sets up a starter lono project called infra with example templates.  Next you cd into the folder and generate the template and parameter files.

<pre>
$ cd infra
$ lono generate
</pre>

This CloudFormation template and parameter files are now available under `output` and `output/params`.

### Generate Template Files

The CloudFormation templates files that were generated from the `config` and `templates` folders and written to the `output` folder.

The starter lono template project config files looks like [this](lib/starter_project_yaml/config/lono.rb) and [this](lib/starter_project_yaml/config/lono/api.rb).  Here's a snippet from one of the config files: [config/lono.rb](lib/starter_project_yaml/config/lono.rb).

```ruby
template "api-web-prod.yml" do
  app,role,env = name.sub('.yml','').split('-')
  source "web.yml.erb"
  variables(
    env: env,
    app: app,
    role: role,
    ami: "ami-123",
    instance_type: "m1.small",
    port: "80",
    high_threshold: "15",
    high_periods: "4",
    low_threshold: "5",
    low_periods: "10",
    max_size: "24",
    min_size: "6",
    down_adjustment: "-3",
    up_adjustment: "3",
    ssl_cert: "arn:aws:iam::12345:server-certificate/wildcard"
  )
end
```

Here is the corresponding ERB template [templates/web.yml.erb](lib/starter_project_yaml/templates/web.yml.erb).  Note that some of the source code has been shorten for brevity.

```yaml
<% @app,@role,@env = name.sub('.yml','').split('-') -%>
---
AWSTemplateFormatVersion: '2010-09-09'
Description: <%= @app.capitalize %> Stack
Mappings:
...
Outputs:
...
Parameters:
  Application:
    Default: <%= @app %>
    Description: Application name
    Type: String
...
Resources:
  CPUAlarmHigh:
    Properties:
      AlarmActions:
      - Ref: WebServerScaleUpPolicy
      AlarmDescription: Scale-up if CPU > <%= @high_threshold %>% for <%= @high_mins %>
...
<%= partial("host_record.yml.erb", domain: "mydomain.com") %>
  LaunchConfig:
    Properties:
      BlockDeviceMappings:
      - DeviceName: "/dev/sdb"
        VirtualName: ephemeral0
      ImageId:
...
      UserData:
        Fn::Base64: !Sub | # No more Fn::Join needed
          #!/bin/bash -lexv
          <% stack_name = "#{@env}-#{@app}-#{@role}" %>
          exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
          echo <%= stack_name %> > /tmp/stack_name
          cat /proc/uptime | cut -f1 -d'.' > /tmp/time-to-boot
    Type: AWS::AutoScaling::LaunchConfiguration

```

The generated `output/blog-web-prod.yml` CloudFormation template looks like this:

```yaml
---
AWSTemplateFormatVersion: '2010-09-09'
Description: Api Stack
Mappings:
...
Outputs:
...
Parameters:
  Application:
    Default: api
    Description: Application name
    Type: String
...
Resources:
  CPUAlarmHigh:
    Properties:
      AlarmActions:
      - Ref: WebServerScaleUpPolicy
      AlarmDescription: Scale-up if CPU > 15% for
...
  HostRecord:
    Properties:
      Comment: DNS name for mydomain.com
      HostedZoneName: ".mydomain.net."
      Name:
        Fn::Join:
        - ''
        - - Ref: AWS::StackName
          - mydomain.com
      ResourceRecords:
      - Fn::GetAtt:
        - elb
        - DNSName
      TTL: '60'
      Type: CNAME
    Type: AWS::Route53::RecordSet
  LaunchConfig:
    Properties:
      BlockDeviceMappings:
      - DeviceName: "/dev/sdb"
        VirtualName: ephemeral0
      ImageId:
...
      UserData:
        Fn::Base64: |
          #!/bin/bash -lexv

          exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
          echo api-web-prod > /tmp/stack_name
          cat /proc/uptime | cut -f1 -d'.' > /tmp/time-to-boot
    Type: AWS::AutoScaling::LaunchConfiguration
```

You can use the generated CloudFormation templates in the `output` folder just as you would a normal CloudFormation template.  Here's a flow chart of the overall process.

![Lono flowchart](http://tongueroo.com/images/github-readmes/lono-flowchart.png "Lono flowchart")

### Generate Parameter Files

With lono you write simpler params file that is formatted with a simple `key=value` env-like file.  The `params/mystack.txt` is shorter format versus the verbose standard CloudFormation parameters json file. Here is an example of a simple `params/mystack.txt` param file.

```bash
Param1=1
Param2=2
```

The `lono generate` command generates the CloudFormation parameter file in `output/params/mystack.json` which looks like this:


```json
[
  {
    "ParameterKey": "Param1",
    "ParameterValue": "1"
  },
  {
    "ParameterKey": "Param2",
    "ParameterValue": "2"
  }
]
```

## Template helper methods

There are helper methods that are available in templates.

* partial(relative_path, variables, options) - Can be use to embed other files in a template.  The partial view should be placed in the `templates/partial` folder of the project.  So:
  * partial('launch\_config.json.erb') -> `templates/partial/launch_config.json.erb`
  * partial('launch\_config.json.erb', foo: "bar", hello: "world") - variables can be passed to the partial helper method are available to the partial as instance variables.  So, in this case `@foo` and `@hello` will be available in the `launch_config.json.erb` partial.
  * partial('user_data/bootstrap.sh.erb', {}, indent: 10) - Indent the result partial by 10 spaces.  Useful for yaml format.

* user\_data - Helpful if you are using CloudFormation json format. More info on the [wiki page](https://github.com/tongueroo/lono/wiki/user_data-helper-for-json-format).

## Breaking up config/lono.rb

If you have a lot of templates, the config/lono.rb file can get unwieldy long.  You can break up the lono.rb file and put template defintions in the config/lono directory.  Any file in this directory will be automatically loaded. An [example](lib/starter_project_yaml/config/lono/api.rb) is in the starter project.


## Generate

You can generate the CloudFormation templates by running:

<pre>
$ lono generate
$ lono g -c # shortcut
</pre>

The lono init command also sets up guard-lono.  Guard-lono continuously generates the cloudformation templates.  Just run guard.

<pre>
$ guard
</pre>

# lono cfn

## Summary
Lono also provides a `lono cfn` wrapper command that allows you to launch stacks from the lono templates.  The `lono cfn` tool automatically runs `lono generate` internally and then launches the CloudFormation stack all in one command.  Provided that you are in a lono project and have a `my-stack` lono template definition.  To create a stack you can simply run:

```
$ lono cfn create my-stack
```

The above command will generate files to `output/my-stack.json` and `output/params/my-stack.txt` and use them to create a CloudFormation stack.  Here are some more examples of cfn commands:

```
$ lono cfn create mystack-$(date +%Y%m%d%H%M%S) --template mystack --params mystack
$ lono cfn create mystack-$(date +%Y%m%d%H%M%S) # shorthand if template and params file matches.
$ lono cfn diff mystack-1493859659
$ lono cfn preview mystack-1493859659
$ lono cfn update mystack-1493859659
$ lono cfn delete mystack-1493859659
$ lono cfn create -h # getting help
```

### Conventions

The template by convention defaults to the name of the stack.  In turn, the params by convention defaults to the name of the template.

* stack - This is a required parameter and is the CLI first parameter.
* template - By convention matches the stack name but can be overriden with `--template`.
* params - By convention matches the template name but can be overriden with `--params`.

The conventions allows the command to be a very nice short command that can be easily remembered.  For example, these 2 commands are the same:

### lono cfn create

Long form:

```
$ lono cfn create my-stack --template my-stack --params --my-stack
```

Short form:

```
$ lono cfn create my-stack
```


Both template and params conventions can be overridden.  Here are examples of overriding the template and params name conventions.

```
$ lono cfn create my-stack --template different-name1
```

The template that will be use is output/different-name1.json and the parameters will use params/different-name1.json.

```
$ lono cfn create my-stack --params different-name2
```

The template that will be use is output/different-name2.json and the parameters will use params/different-name2.json.

```
$ lono cfn create my-stack --template different-name3 --params different-name4
```

The template that will be use is output/different-name3.json and the parameters will use params/different-name4.json.

### lono cfn update

To update stacks you can use `lono cfn update`:

```
$ lono cfn update my-stack --template template-name --params params-name
```

By default the update command will display a preview of the stack changes before applying the update and prompt to check if you are sure.  If you want to bypass the are you sure prompt, use the `--sure` option.

```
$ lono cfn update my-stack --template template-name --params params-name --sure
```

### lono cfn delete

```
$ lono cfn delete my-stack --sure
```

### lono cfn preview

If you want to see the CloudFormation preview without updating the stack you can also use the `lono cfn preview` command.  The preview command is also covered in this blog post: [AWS CloudFormation dry-run with lono cfn preview](https://medium.com/boltops/aws-cloudformation-dry-run-with-lono-cfn-plan-2a1e0f80d13c)

```
$ lono cfn preview example --template single_instance --params single_instance
Using template: output/single_instance.yml
Using parameters: params/single_instance.txt
Generating CloudFormation templates:
  ./output/single_instance.yml
Params file generated for example at ./output/params/example.json
Generating CloudFormation Change Set for preview.....
CloudFormation preview for 'example' stack update. Changes:
Remove AWS::Route53::RecordSet: DnsRecord testsubdomain.sub.tongueroo.com
$
```


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
