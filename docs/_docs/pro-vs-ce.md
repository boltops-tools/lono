---
title: Pro vs Community Edition
nav_order: 6
---

Lono Pro is a paid version that adds additional features. It is available with a [BoltOps Pro subscription](https://boltops.com/pro) and to select BoltOps customers.

Lono Community Edition is a free version of Lono.  It is available for anyone to use under an [Source Available license](https://www.boltops.com/boltops-community-license).

## What's the Difference Between Pro vs Community Edition?

&nbsp; | Pro | Community
--- | --- | ---
CFN Lifecycle commands | ![](/img/features/yes.svg) | ![](/img/features/yes.svg)
ERB Template Generator | ![](/img/features/yes.svg) | ![](/img/features/yes.svg)
DSL Generator | ![](/img/features/yes.svg) | ![](/img/features/yes.svg)
Reusable Blueprints | ![](/img/features/yes.svg) | ![](/img/features/yes.svg)
Import and Convert commands | ![](/img/features/yes.svg) | ![](/img/features/no.svg)
Access to BoltOps Pro blueprints | ![](/img/features/yes.svg) | ![](/img/features/no.svg)

## What are BoltOps Pro Blueprints?

BoltOps Pro blueprints are reusable CloudFormation templates built and managed by BoltOps.  They are configurable to fit your needs. They are also documented and tested in a daily build process. Essentially, they save you time.

A list of the blueprints is available at: [boltopspro-docs](https://github.com/boltopspro-docs).

## Import and Convert Commands

Lono features a powerful DSL to build CloudFormation templates. It is recommended to use the Lono DSL because it results in maintainable code in the long-term. Most CloudFormation templates in the wild are written in JSON or YAML.

The `lono  convert` and `lono import` commands allow you to take JSON or YAML templates and convert it to the Lono DSL code.  It is a beta feature. The conversion process should get you 80% of way there.

## Docs

The docs for both Lono Community Edition and additional Pro features are on [lono.cloud](https://lono.cloud). Pro features are noted accordingly.

{% include prev_next.md %}
