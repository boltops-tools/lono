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

This generates the templates that have been defined in the config folder of the lono project.

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

* user_data - can be used to include a user data script which is written in bash script form.  The user data script should be placed in the templates/user_data folder of the project.  So:
  * user_data('bootstrap.sh.erb') -> templates/user_data/bootstrap.sh.erb
  * user_data('db.sh.erb') -> templates/user_data/db.sh.erb

Here's how you would call it in the template.

```json
"UserData": {
  "Fn::Base64": {
    "Fn::Join": [
      "",
      <%= user_data('bootstrap.sh.erb') %>
    ]
  }
```

Within a user_data script you can user helper methods that correspond to Cloud Formation [Instrinic Functions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/concept-intrinsic-functions.html).  Currently, base64, find_in_map, get_att, get_azs, join, and ref are supported.  Examples of their usage are found in the starter [project template](https://github.com/tongueroo/lono/blob/master/lib/starter_project/templates/user_data/db.sh.erb)

## Converting UserData scripts

You can convert UserData scripts in existing Cloud Formation Templates to a starter bash script via:

<pre>
$ lono bashify cloud_formation_template.json
$ lono bash cloud_formation_template.json # shorthand
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