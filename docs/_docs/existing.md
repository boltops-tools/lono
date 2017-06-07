---
title: Build from Existing Template
---

If you already have an existing CloudFormation template and would like to add it to a lono project it is a straightforward process.  We will use `lono new` to get quickly up and running.

```sh
lono new infra
cd infra
```

#### Download Existing Template

For this example, I'm going to download the [Load-based auto scaling](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-east-1.html#w1ab2c21c39c15b9) from the official AWS CloudFormation documentation.

```sh
curl -o "asg.json" https://s3.amazonaws.com/cloudformation-templates-us-east-1/AutoScalingMultiAZWithNotifications.template
```

You can use either the download json format or convert it to yaml with this command:

```sh
ruby -ryaml -rjson -e 'puts YAML.dump(JSON.load(ARGF))' < asg.json > templates/asg.yml.erb
```

Notice that you named the template with a `.erb` extension.

#### Inspect Template Parameters

Before deleting the `asg.json` file let's `jq` to inspect the parameter values.

```sh
$ cat templates/asg.json | jq -r '.Parameters | to_entries[] | {name: .key, default: .value.Default} | select(.default == null) | .name'
VpcId
Subnets
OperatorEMail
KeyName
$ rm -f asg.json
```

With this info, we can now create a lono params file.  Your `params/asg.txt` file should look similar to this:

```
VpcId=vpc-427d5123 # should use your real vpc
Subnets=subnet-36f48123,subnet-f0a83123,subnet-b2c52123
OperatorEMail=me@hello.com
KeyName=tutorial
```

#### Configure the template

Remember to add a template declaration in the `config/lono.rb` file.  It should look like this:

```ruby
template "asg.yml" do
  source "asg.yml.erb"
end
```

#### Launch the Stack

That's it!  You are ready to launch the stack.  Run the following:

```sh
$ lono cfn create asg
```

Congratulations! 🍾 You have successfully added an existing CloudFormation template to a lono project.

<a class="btn btn-basic" href="{% link _docs/directory-structure.md %}">Back</a>
<a class="btn btn-primary" href="{% link examples.md %}">Next Step</a>
