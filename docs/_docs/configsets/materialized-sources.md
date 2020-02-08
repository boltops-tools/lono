---
title: Materialized Gem Sources
nav_text: Materialized Sources
categories: configsets
order: 10
nav_order: 33
---

{% include configsets/materialized.md header=false %}

## Setting Materialized Source

The source for materialized configsets can be control in a few ways.  Here they are in the order of highest to lowest precedence.

1. configset option
2. Environment Variable
3. configs/settings.yml

## configset option

```ruby
configset("cfn-hup", resource: "Instance", source: "git@github.com:boltopspro/cfn-hup")
```

## Environment

Setting the `LONO_MATERIALIZED_GEMS_SOURCE` env variable will set the source. Example:

    export LONO_MATERIALIZED_GEMS_SOURCE=git@github.com:boltopspro

## configs/settings.yml

Setting the `materialized_gems.source` settings will set the source. Example:

```yaml
base:
  materialized_gems:
    source: git@github.com:boltopspro
```

## Materialized source GitHub orgs support

Notice with the "configset option", you specify the full source **with** the repo name.  With the Environment and `configs/settings.yml`, you do **not** specify the repo name.

Materialized sources are not typical Gemfile gem sources. They infer the repo name from the configset name.  If the repo name is different from configset, then you can explicitly specify `repo` in the `configset` definition.  Example:

app/blueprints/ec2/config/configsets.rb:

```ruby
configset "cfn-hup", resource: "Instance", repo: "cfn-hup-repo"
```

{% include prev_next.md %}
