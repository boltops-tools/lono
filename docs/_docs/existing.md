---
title: Build from Existing Template
---

If you already have an existing CloudFormation template and would like to add it to a lono project it is a straightforward process.  A summary of the process:

1. Download template and move it into the templates folder
2. Create a params file associated with downloaded stack
3. Add a template declaration to `config/lono.rb`

We will use `lono new` to get quickly up and running.

```sh
lono new infra
cd infra
```

#### Download Existing Template

For this example, I'm going to download the [Load-based auto scaling](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-east-1.html#w1ab2c21c39c15b9) from the official AWS CloudFormation documentation.

```sh
curl -o "asg.json" https://s3.amazonaws.com/cloudformation-templates-us-east-1/AutoScalingMultiAZWithNotifications.template
```

You can use either the downloaded json format or convert it to yaml with this command:

```sh
ruby -ryaml -rjson -e 'puts YAML.dump(JSON.load(ARGF))' < asg.json > templates/asg.yml.erb
```

Notice that you named the template with a `.erb` extension.

#### Inspect Template Parameters

Before deleting the `asg.json` file let's use it and `jq` to inspect the possible parameter that the CloudFormation expects.

```sh
$ cat asg.json | jq -r '.Parameters | to_entries[] | {name: .key, default: .value.Default} | select(.default == null) | .name'
VpcId
Subnets
OperatorEMail
KeyName
```

Let's create a starter `params/asg.txt` file.

```sh
cat asg.json | jq -r '.Parameters | to_entries[] | {name: .key, default: .value.Default} | select(.default == null) | .name' | sed 's/$/=/' > params/asg.txt
```

We no longer need the `asg.json` file so we'll delete it:

```sh
rm -f asg.json
```

Now we can create a lono params file.  Your `params/asg.txt` file should look similar to this:  Substitute the values from your own AWS account.

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

<a id="prev" class="btn btn-basic" href="{% link _docs/new.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/next-steps.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

