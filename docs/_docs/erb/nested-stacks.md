---
title: Nested Stack Support
categories: erb
nav_order: 98
---

Lono provides helper methods to help work with nested CloudFormation templates.

Helper  | Description
------------- | -------------
`template_s3_path(name)`  | This is the s3 path where template gets uploaded to s3. This required for the `TemplateURL` property of an `AWS::CloudFormation::Stack` child stack resource.
`template_params(name)`  | This returns an Array of the parameter values. This is useful in a parent template if you are using nested templates. You can use this to grab the params values from child templates and specify the parameters within the parent template to other child templates.

### The template_s3_path helper

Instead of hard-coding the s3 bucket and path name in your parent stack you can use this helper to reference it from code.  You use it in your `app/templates/parent.yml` like so:

```ruby
<%= template_s3_path("ChildTemplate") %>
```

This produces the url in your `output/templates/parent.yml`:

```ruby
https://s3.amazonaws.com/lono-bucket/templates/production/ChildTemplate.yml
```

Note that the `LONO_ENV` is added to the final s3 path in case you are using the same s3 bucket for multiple environments.

### The template_params helper

Typically child templates in a nested stack setup use parameters specified in the parent stack template definition. The `template_params` helper allows you to grab the parameter values in the params files and inject them into the parent template. This allows you to launch the child template as separate stand-alone stacks using the runtime `params` values or as an embedded child stack using those same parameter values. Example:

`templates/parent.yml`:

```yaml
...
Resources:
  Network:
    Type: AWS::CloudFormation::Stack
    Properties:
      TemplateURL: <%= template_s3_path("network") %>
      Parameters:
      <% template_params("network").each do |key, value| %>
        <%= key %>: <%= value %>
      <% end %>
        CIDR: 10.11.0.0/16
...
```

`templates/child.yml`:

```yaml
...
Resources:
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock:
...
```

`params/base/child.txt`:

```sh
VpcName=main
DomainName=stack.local
```

Note you might want to put inline parameter values in the parent template at the bottom after the `template_params` loop, so it is clear what the final values parameters being passed into the child template are.

{% include prev_next.md %}
