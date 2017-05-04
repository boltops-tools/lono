# Lono

[![ReadmeCI](http://www.readmeci.com/images/readmeci-badge.svg)](http://www.readmeci.com/tongueroo/lono)
[![Gem Version](https://badge.fury.io/rb/lono.png)](http://badge.fury.io/rb/lono)
[![Build History][2]][1]
[![Code Climate][3]][4]
[![Dependency Status](https://gemnasium.com/tongueroo/lono.png)](https://gemnasium.com/tongueroo/lono)
[![Coverage Status](https://coveralls.io/repos/tongueroo/lono/badge.png)](https://coveralls.io/r/tongueroo/lono)

[1]: http://travis-ci.org/tongueroo/lono
[2]: https://secure.travis-ci.org/tongueroo/lono.png?branch=master
[3]: https://codeclimate.com/repos/51d7f1407e00a4042c010ab4/badges/5273fe6cdb5a13e58554/gpa.png
[4]: https://codeclimate.com/repos/51d7f1407e00a4042c010ab4/feed

Lono is a CloudFormation Template generator.  Lono generates CloudFormation templates based on ERB ruby templates.

## Usage

<pre>
$ lono new infra
</pre>

This sets up a starter lono project called infra with example templates.  Next you cd into the folder and generate the templates.

<pre>
$ cd infra
$ lono generate
</pre>

This generates the templates in the `config` and `templates` folders to the `output` folder.

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

You can generate the CF templates by running:

<pre>
$ lono generate
$ lono g -c # shortcut
</pre>

The lono init command also sets up guard-lono.  Guard-lono continuously generates the cloudformation templates.  Just run guard.

<pre>
$ guard
</pre>

## lono-cfn and lono-params

Running `lono generate` and building up the `aws cloudformation create-stack` command repeatedly gets old. The `lono-cfn` tool will automatically run `lono generate` and then launch the CloudFormation stack all in one command.  Example usage:

```
$ lono-cfn create mystack-$(date +%Y%m%d%H%M%S) --template mystack --params mystack
$ lono-cfn create mystack-$(date +%Y%m%d%H%M%S) # shorthand if template and params file matches.
```

More info about lono-cfn here: [lono-cfn](https://github.com/tongueroo/lono-cfn) - Wrapper cfn tool to quickly create CloudFormation stacks from lono templates and params files.

The params file is formatted with a simple `key=value`, env-like file.  It is cleaner to have a `params/mystack.txt` file like so:

```bash
Param1=1
Param2=2
```

Verus the rather verbose standard CloudFormation parameters json file:

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

More info about lono-parmas here: [lono-params](https://github.com/tongueroo/lono-params) - Tool to generate a CloudFormation parameters json formatted file from a simplier env like file.
