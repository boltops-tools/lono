---
title: Configure the Template
---

Let's configure the `@route53` variable in the template in the previous section. You configure this in the `templates/lono.rb` file.  Add the following to your `config/lono.rb` file:

```ruby
template "single_instance.yml" do
  source "instance.yml.erb"
end

template "instance_and_route53.yml" do
  source "instance.yml.erb"
  variables(
    route53: true
  )
end
```

This will tell lono to generate 2 CloudFormation template to the output folder using `templates/instance.yml.erb`.  We will generate the templates in the next step.

<a class="btn btn-basic" href="/docs/scratch-template-build/">Back</a>
<a class="btn btn-primary" href="/docs/scratch-template-generate/">Next Step</a>
