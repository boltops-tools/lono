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

The starter lono template project config files looks like [this](lib/starter_project/config/lono.rb) and [this](lib/starter_project/config/lono/api.rb).  Here's a snippet from one of the config files with the template call:

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

The corresponding ERB template looks like the following.  Note that some of the output has been shorten for brevity.

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

The output looks like this:

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

* partial(relative_path, variables, options) - can be use to embed other files in a template.  The partial view should be placed in the `templates/partial` folder of the project.  So:
  * partial('launch\_config.json.erb') -> `templates/partial/launch_config.json.erb`
  * partial('launch\_config.json.erb', foo: "bar", hello: "world") - variables can be passed to the partial helper method are available to the partial as instance variables.  So, in this case `@foo` and `@hello` will be available in the `launch_config.json.erb` partial.
  * partial('user_data/bootstrap.sh.erb', {}, indent: 10) - Indent the result partial by 10 spaces.  Useful for yaml format.

## user\_data helper for json format

The user\_data helper method is helpful for writting a script in bash form and having lono convert it to a json compatiable format. It is only really useful if you are using json as the CloudFormation format.  If you are using yaml as the format, which is recommended, then you should simply use raw yaml.

* user\_data - can be used to include a user data script which is written in bash script form.  The user data script should be placed in the `templates/user_data` folder of the project.  So:
  * user\_data('bootstrap.sh.erb') -> templates/user\_data/bootstrap.sh.erb
  * user\_data('db.sh.erb') -> templates/user\_data/db.sh.erb
  * user\_data('script1.sh.erb', foo: "bar", hello: "world") - variables can be passed to the user\_data helper method and will be available to the partial as instance variables.  So, in this case `@foo` and `@hello` will be available in `script1.sh.erb`.

Here's how you would call it in the template.

```json
"UserData": {
  "Fn::Base64": {
    "Fn::Join": [
      "",
      [
        <%= user_data('db.sh.erb') %>
      ]
    ]
  }
```

Within the user\_data script you can use helper methods that correspond to CloudFormation [Instrinic Functions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/concept-intrinsic-functions.html).  Currently, `base64`, `find_in_map`, `get_att`, `get_azs`, `join`, and `ref` are supported.  Here's a short example of a user\_data script using a helper method:

If you have a `templates/user_data/db.sh.erb` that looks like this:

```bash
#!/bin/bash -lexv

HOSTNAME_PREFIX=<%= find_in_map("EnvironmentMapping", "HostnamePrefix", ref("Environment")) %>

echo <%= ref("AWS::StackName") %> > /tmp/stack_name
# Helper function
function error_exit
{
  /usr/local/bin/cfn-signal -e 1 -r "$1" '<%= ref("WaitHandle") %>'
exit 1
}
# Wait for the EBS volume to show up
while [ ! -e /dev/xvdf ]; do echo Waiting for EBS volume to attach; sleep 1; done
/bin/mkdir /media/redis
/sbin/mkfs -t ext4 /dev/xvdf
echo "/dev/xvdf /media/redis auto defaults 0 0" >> /etc/fstab
/bin/mount /media/redis
/usr/bin/redis-cli shutdown
sleep 10
mv /var/lib/redis/* /media/redis/
rm -r /var/lib/redis
ln -s /media/redis /var/lib/redis
chown -R redis:redis /var/lib/redis
chown -R redis:redis /media/redis
/usr/bin/redis-server
# If all is well so signal success
/usr/local/bin/cfn-signal -e $? -r "Ready to rock" '<%= ref("WaitHandle") %>'
```

The user\_data helper will transform the bash script into a json array of elements for CloudFormation:

```json
[
  "#!/bin/bash -lexv\n",
  "\n",
  "HOSTNAME_PREFIX=",
  {
    "Fn::FindInMap": [
      "EnvironmentMapping",
      "HostnamePrefix",
      {
        "Ref": "Environment"
      }
    ]
  },
  "\n",
  "\n",
  "echo ",
  {
    "Ref": "AWS::StackName"
  },
  " > /tmp/stack_name\n",
  "# Helper function\n",
  "function error_exit\n",
  "{\n",
  "  /usr/local/bin/cfn-signal -e 1 -r \"$1\" '",
  {
    "Ref": "WaitHandle"
  },
  "'\n",
  "exit 1\n",
  "}\n",
  "# Wait for the EBS volume to show up\n",
  "while [ ! -e /dev/xvdf ]; do echo Waiting for EBS volume to attach; sleep 1; done\n",
  "/bin/mkdir /media/redis\n",
  "/sbin/mkfs -t ext4 /dev/xvdf\n",
  "echo \"/dev/xvdf /media/redis auto defaults 0 0\" >> /etc/fstab\n",
  "/bin/mount /media/redis\n",
  "/usr/bin/redis-cli shutdown\n",
  "sleep 10\n",
  "mv /var/lib/redis/* /media/redis/\n",
  "rm -r /var/lib/redis\n",
  "ln -s /media/redis /var/lib/redis\n",
  "chown -R redis:redis /var/lib/redis\n",
  "chown -R redis:redis /media/redis\n",
  "/usr/bin/redis-server\n",
  "# If all is well so signal success\n",
  "/usr/local/bin/cfn-signal -e $? -r \"Ready to rock\" '",
  {
    "Ref": "WaitHandle"
  },
  "'\n"
]
```

More examples of user\_data and instrinic function helper method usage are found in the starter [project template](https://github.com/tongueroo/lono/blob/master/lib/starter_project_json/templates/user_data/db.sh.erb)

## Converting UserData scripts

You can convert UserData scripts in existing CloudFormation Templates to a starter bash script via:

<pre>
$ lono bashify cloud_formation_template.json
$ lono bash cloud_formation_template.json # shorthand
$ lono b https://s3.amazonaws.com/cloudformation-templates-us-east-1/LAMP_Single_Instance.template # shorthand and url
</pre>

This is useful if you want to take an existing json [CloudFormation Template example](http://aws.amazon.com/cloudformation/aws-cloudformation-templates/) and quicklly change the UserData section into a bash script. The bashify command will generate a snippet that is meant to be copied and pasted into a bash script and used with user\_data helper method.  The bash script should work right off the bat as lono will transform the generated CloudFormation object references to json objects, there's no need to manually change what is generated to the helper methods, though you can if you prefer the look of the helper methods.

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
