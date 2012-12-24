# Lono

Lono is a Cloud Formation Template ruby generator.  Lono generates Cloud Formation templates based on ERB templates.

## Usage

<pre>
$ gem install lono
$ mkdir lono_project
$ lono init 
</pre>

This sets up the basic lono project with an example template in source/app.json.erb.

<pre>
$ lono generate
</pre>

This generates the templates that have been defined in config/lono.rb.

The example starter config/lono.rb looks like this:

```ruby
template "prod-api-app.json" do
  source "app.json.erb"
  variables(
    :env => 'prod',
    :app => 'api',
    :role => "app",
    :ami => "ami-123",
    :instance_type => "c1.xlarge",
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
template "prod-br-app.json" do
  source "app.json.erb"
  variables(
    :env => "prod",
    :app => 'br',
    :role => "app",
    :ami => "ami-456",
    :instance_type => "m1.medium",
    :port => "80",
    :high_threshold => "35",
    :high_periods => "4",
    :low_threshold => "20",
    :low_periods => "2",
    :max_size => "6",
    :min_size => "3",
    :down_adjustment => "-1",
    :up_adjustment => "2"
  )
end
```

The example ERB template file is in templates/app.json.erb.

<pre>
$ guard
</pre>

The lono init comamnd also sets up guard-lono and guard-cloudformation.  Guard-lono continuously generates the cloud formation templates and guard-cloudformation continuously verifies that the cloud formation templates are valid via AWS's cfn-validate-template command.

## User Data Helper

In the template files, there's user_data helper method available which can be used to include a user data script.  The user data script should be in in the config/lono folder of the project.  So:

* user_data('bootstrap.sh') corresponds to config/lono/bootstrap.sh
* user_data('db.sh') corresponds to config/lono/db.sh

Here's how you would call it in the template.

```json
"UserData": {
  "Fn::Base64": {
    "Fn::Join": [
      "",
      [
        <%= user_data('bootstrap.sh') %>
      ]
    ]
  }
```