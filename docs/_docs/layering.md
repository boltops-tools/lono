---
title: Layering Support
---

Lono supports a concept called layering.  Layering is how lono merges multiple files together to produce a final result.  This is useful for building multiple environments. For example, it is common to build a production and staging environment.  Most of the stack is the same except for a few parts that require specific environment overrides.  Lono's layering ability makes this extremely simple to do.

Going through a few examples of how lono performs layering will help make it clear the power of layering.

### Templates Layering

You configured your lono templates in the `config/templates` folder. The starter project sets up a standard directory structure that layering is designed for.  Here's an example structure:

```sh
└── config
    └── templates
        ├── base
        │   ├── blog.rb
        │   └── stacks.rb
        ├── prod
        │   └── stacks.rb
        └── stag
            └── stacks.rb
```

Let's say these `stack.rb` files contain the following template definitions.

`config/templates/base/stacks.rb`:

```ruby
template "example" do
  source "example"
end
```
`config/templates/prod/stacks.rb`:

```ruby
template "example" do
  source "example-prod"
end
```

`config/templates/stag/stacks.rb`:

```ruby
template "example" do
  source "example-stag"
end
```

Essentially with layering, when `lono generate` is called it will first evaluate all the template definitions in `config/templates/base` folder and then evaluate all the template definitions in the specific `LONO_ENV` folder.  This layering results in lono generating  different `output/templates.yml` with different template source views based on what `LONO_ENV` is set to. For example:

```sh
LONO_ENV=prod lono generate # output/example.yml uses templates/example-prod.yml
LONO_ENV=stag lono generate # output/example.yml uses templates/example-stag.yml
LONO_ENV=sandbox lono generate # output/example.yml uses templates/example.yml
```

Notice, how for `LONO_ENV=sandbox` because there are no `config/templates/sandbox` files only the `config/templates/base/stacks.rb` definition is used.

The layering ability of the templates definitions allows you to override which template view to use based on `LONO_ENV`. With this ability, you can have common infrastructure code in the base folder and override the specific environment parts.

### Variables Layering

Layering is also performed for the `config/variables` folder.  Let's say you have the following variables directory structure:

```yaml
├── base
│   └── variables.rb
├── prod
│   └── variables.rb
└── stag
    └── variables.rb
```

In this case, you want to define your common variables used for templates in the `config/templates/base` folder. Any specific environment overrides should be defined in their respective `LONO_ENV` folder.  For example:

`config/templates/base/variables.rb`:

```ruby
@min_size = 1
@max_size = 1
```

`config/templates/prod/variables.rb`:

```ruby
@min_size = 10
@max_size = 20
```

When `lono generate` is called with `LONO_ENV=prod` it will use `20` for the `@max_size` variable. For other `LONO_ENV` values, the `@max_size` variable will be set to `1`.

### Params Layering

Layering is also performed during param generation.  For example, given the following param structure:

```sh
├── base
│   └── example.txt
├── prod
│   └── example.txt
└── stag
    └── example.txt
```

When launching the example stack, lono will overlay the `LONO_ENV` specific param values on top of the base params values and use that result.  For example, given:

`param/base/example.txt`:

```sh
InstanceType=m4.medium
```

`param/stag/example.txt`:

```sh
InstanceType=m4.small
```

Lono will use the `m4.small` as the InstanceType parameter value when launching the stack with `LONO_ENV=stag`.  Lono will use `InstanceType=m4.medium` for all other `LONO_ENV` values.  Example:

```sh
$ LONO_ENV=prod lono cfn create example # InstanceType=m4.medium
$ LONO_ENV=stag lono cfn create example # InstanceType=m4.small
```

### Summary

Lono's layering concept provides you with the ability to define common infrastructure components and override them for specific environments when necessary. This helps you build multiple environments in an organized way. The layering processing happens for these lono components:

* config/templates - your template definitions and configurations.
* config/variables - your shared variables available to all of your templates.
* params - the runtime parameters you would like the stack to be launched with.

<a id="prev" class="btn btn-basic" href="{% link _docs/params.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/template-helpers.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
