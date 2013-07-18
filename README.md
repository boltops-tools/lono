# Lono

[![Build History][2]][1]

[1]: http://travis-ci.org/tongueroo/lono
[2]: https://secure.travis-ci.org/tongueroo/lono.png?branch=master

Lono is a Cloud Formation Template ruby generator.  Lono generates Cloud Formation templates based on ERB templates.

## Usage

<pre>
$ gem install lono
$ mkdir lono
$ cd lono
$ lono init
</pre>

This sets up a starter lono project with example templates.

<pre>
$ lono generate
</pre>

This generates the templates that have been defined in the config folder of the lono project to the output folder.

The starter lono template project config files looks like [this](lib/starter_project/config/lono.rb) and [this](lib/starter_project/config/lono/api.rb).  Here's a snippet from one of the config files with the template call:

```ruby
template "prod-api-app.json" do
  env,app,role = name.sub('.json','').split('-')
  source "app.json.erb"
  variables(
    :env => env,
    :app => app,
    :role => role,
    :ami => "ami-123",
    :instance_type => "m1.small",
    :port => "80",
    :high_threshold => "15",
    :high_periods => "4",
    :low_threshold => "5",
    :low_periods => "10",
    :max_size => "24",
    :min_size => "6",
    :down_adjustment => "-3",
    :up_adjustment => "3",
    :ssl_cert => "arn:aws:iam::12345:server-certificate/wildcard"
  )
end
```

The corresponding ERB template example file is [here](lib/starter_project/templates/app.json.erb).

## Template helper methods

There are helper methods that are available in templates.

* partial - can be use to embed other files in a template.  The partial should be placed in the templates/partial folder of the project.  So:
  * partial('launch_config.json.erb') -> templates/partial/launch_config.json.erb
  * partial('launch_config.json.erb', :foo => "bar", :hello => "world") - variables can be passed to the partial helper method and will be available to the partial as instance variables.  So, in this case @foo and @hello will be available in the launch_config.json.erb partial.

* user_data - can be used to include a user data script which is written in bash script form.  The user data script should be placed in the templates/user_data folder of the project.  So:
  * user_data('bootstrap.sh.erb') -> templates/user_data/bootstrap.sh.erb
  * user_data('db.sh.erb') -> templates/user_data/db.sh.erb
  * user_data('script1.sh.erb', 'script2.sh.erb') - multiple files can be used to build the user_data script, script1 and script2 will be combined

Here's how you would call it in the template.

```json
"UserData": {
  "Fn::Base64": {
    "Fn::Join": [
      "",
      <%= user_data('db.sh.erb') %>
    ]
  }
```

Within the user_data script you can use helper methods that correspond to Cloud Formation [Instrinic Functions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/concept-intrinsic-functions.html).  Currently, base64, find_in_map, get_att, get_azs, join, and ref are supported.  Here's a short example of a user_data script using a helper method:

If you have a templates/user_data/db.sh.erb that looks like this:

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

The user_data helper will transform the bash script into a json array of elements for Cloud Formation:

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

More examples of user_data and instrinic function helper method usage are found in the starter [project template](https://github.com/tongueroo/lono/blob/master/lib/starter_project/templates/user_data/db.sh.erb)

## Converting UserData scripts

You can convert UserData scripts in existing Cloud Formation Templates to a starter bash script via:

<pre>
$ lono bashify cloud_formation_template.json
$ lono bash cloud_formation_template.json # shorthand
$ lono b https://s3.amazonaws.com/cloudformation-templates-us-east-1/LAMP_Single_Instance.template # shorthand and url
</pre>

This is useful if you want to take an existing [Cloud Formation Template example](http://aws.amazon.com/cloudformation/aws-cloudformation-templates/) and quicklly change the UserData section into a bash script. The bashify command will generate a snippet that is meant to be copied and pasted into a bash script and used with user_data helper method.  The bash script should work right off the bat as lono will transform the generated Cloud Formation object references to json objects, there's no need to manually change what is generated to the helper methods, though you can if you prefer the look of the helper methods.

## Breaking up config/lono.rb

If you have a lot of templates, the config/lono.rb file can get unwieldy long.  You can break up the lono.rb file and put template defintions in the config/lono directory.  Any file in this directory will be automatically loaded. An [example](lib/starter_project/config/lono/api.rb) is in the starter project.


## Generate

You can generate the CF templates by running:

<pre>
$ lono generate
$ lono g -c # shortcut
</pre>

The lono init command also sets up guard-lono.  Guard-lono continuously generates the cloud formation templates.  Just run guard.

<pre>
$ guard
</pre>