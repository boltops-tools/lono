---
title: Template Configuration
---

Template configurations are a core component of lono.  Template configurations are:

1. where you specify the template source to use
2. what variables to make available for those templates
3. where the output template files should be written to

A template configuration takes the following general form:

```ruby
template "[OUTPUT NAME]" do
  source "[SOURCE_NAME]"
  variables(
    [HASH_MAP]
  )
```

Template configurations are defined in the `config/templates` folder of your project.

### Examples

Let's walk through an example. Given:

`config/templates/base/stacks.rb`:

```ruby
template "example-stack" do
  source "example"
  variables(
    app: "example-app",
    instance_type: "m4.small",
    elb: true,
  )
end
```

`templates/example.yml`:

```yaml
Description: <%= @app.capitalize %> Stack
Parameters:
  InstanceType:
    ConstraintDescription: must be a valid EC2 instance type.
    Default: <%= @instance_type %>
    Description: WebServer EC2 instance type
Resources:
...
<% if @elb %>
  elb:
    Properties:
      AvailabilityZones: !GetAZs ""
...
    Type: AWS::ElasticLoadBalancing::LoadBalancer
<% end %>
```

Note that some of the source code is truncated to keep the explanation concise.  In this example, the source is set as `example`. This tells lono to use the template source found at `source/example.yml`.  The `.yml` extension is inferred automatically.

The variables to use are: `app`, `instance_type` and `elb`.  These variables will be available to the `source/example.yml` template.

Lastly, the output name specified is `example-stack`.  This tells lono to generate the output template to `output/example-stack.yml`.  The `.yml` extension is inferred automatically.

When `lono generate` runs, lono uses the information in `config/templates/base/stacks.rb` and files in `templates` to generate templates in the `output` folder.

Template configurations are also layered by lono which is covered in [Layering Support]({% link _docs/layering.md %}).

### Template conventions

The template declaration follows a naming convention that can be used to shorten your template declarations.  Let's say that the template's output name matches the source name:

`config/templates/base/stacks.rb`:

```ruby
template "example" do
  source "example"
  variables(
    app: "example-app",
    instance_type: "m4.small",
    elb: true,
  )
end
```

Since the output and source name are both `example` you can remove the source line and simplify this declaration down to:

```ruby
template "example" do
  variables(
    app: "example-app",
    instance_type: "m4.small",
    elb: true,
  )
end
```

If you do not need to declare any variables within the template block, you can take the code down further.

```ruby
template "example" do
end
```

At this point the `do...end` block is optional so then the template declaration becomes one line:

```ruby
template "example"
```

You might think that you will always need to specify template variables in the code block but it is not always necessary depending on how you use shared variables which are covered next.

<a id="prev" class="btn btn-basic" href="{% link _docs/lono-env.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/config-variables.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
