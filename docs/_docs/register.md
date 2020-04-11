---
title: Register
nav_order: 112
---

Lono has been written from years of experience and provides a workflow that makes CloudFormation much easier. Lono makes it possible to reuse CloudFormation templates. You can deploy the same templates across AWS accounts and build multiple environments.

Lono is available under a [Source Available license](https://www.boltops.com/boltops-community-license) and free to use.  You can download it from RubyGems. Give a spin and see if it's the right fit for you.

If you're using lono, all we ask is that you register. Registration allows lono to be ultimately improved. Registering also allows you to receive updates and special offers, including discounts to [BoltOps Pro]({% link _docs/boltops-pro.md %}). Registration is free and straightforward. You can register at: [Register](https://register.lono.cloud)

Thanks for your support. Your support helps make lono software possible.

## Setup

Configure your registration info with a `.lono/registration.yml` file located in either your project or home folder.  Example:

.lono/registration.yml

```yaml
---
name: Jon Doe
email: jon@email.com
company: Dunder Mifflin
registration_key: EXAMPLE700ca40bc06ea909c40ec143487a10ac1aec7851ac0a3a7dbaEXAMPLE
```

You can confirm the registration info with [lono registration check]({% link _reference/lono-registration-check.md %}). Example:

    $ lono registration check
    Lono registration looks good!
    $

## SSM Support

You can optionally store registration info in [SSM Param Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html). To use them:

.lono/registration.yml:

```yaml
---
name: <%= ssm("/lono/registration/name") %>
company: <%= ssm("/lono/registration/company") %>
email: <%= ssm("/lono/registration/email") %>
registration_key: <%= ssm("/lono/registration/registration_key") %>
```

## Debug Registration

It can be useful to show the registration info being used with the `--debug` option.

    $ lono registration check --debug
    Debug mode enabled. Here's the lono registration info being used:
    ---
    name: Jon Doe
    email: jon@email.com
    company: Dunder Mifflin
    registration_key: EXAMPLE700ca40bc06ea909c40ec143487a10ac1aec7851ac0a3a7dbaEXAMPLE

    Lono registration looks good!
    $

{% include prev_next.md %}
