---
title: ERB Templates
---

## Templates Layering

You configured your lono templates in the `app/definitions` folder. The starter project sets up a standard directory structure that layering is designed for.  Here's an example structure:

    └── app
        └── definitions
            ├── base.rb
            ├── development.rb
            └── production.rb

Let's say these template definition files contain the following:

app/definitions/base.rb:

```ruby
template "example" do
  source "example"
end
```

app/definitions/development.rb:

```ruby
template "example" do
  source "example-dev"
end
```

app/definitions/production.rb:

```ruby
template "example" do
  source "example-prod"
end
```

Essentially with layering, when [lono generate](/reference/lono-generate/) is called it will first evaluate `app/definitions/base.rb` and then evaluate the `LONO_ENV` specific definitions file.  By default `LONO_ENV=development`, so the evaluation order looks like this:

1. app/definitions/base.rb
2. app/definitions/base/* # all files in this folder
3. app/definitions/development.rb
4. app/definitions/development/* # all files this folder

This layering results in lono generating  different `output/templates.yml` with different template source views based on what `LONO_ENV` is set to. For example:

    lono generate # LONO_ENV=development is default, so output/example.yml uses templates/example-dev.yml
    LONO_ENV=production lono generate # output/example.yml uses templates/example-prod.yml
    LONO_ENV=sandbox lono generate # output/example.yml uses templates/example.yml since there is no app/definitions/sandbox.rb yet

Notice, how for `LONO_ENV=sandbox` because there are no `app/definitions/sandbox.rb` the `app/definitions/base.rb` definition is used.

The layering ability of the templates definitions allows you to override which template view to use based on `LONO_ENV`. With this ability, you can have common infrastructure code in the base folder and override the specific environment parts.