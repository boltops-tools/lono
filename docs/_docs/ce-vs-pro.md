---
title: Community Edition vs Pro
nav_order: 7
---

Lono Community Edition is a free version of Lono.  It is available for anyone to use under a [Source Available license](https://www.boltops.com/boltops-community-license).

Lono Pro refers to additional features added to lono. It is available with a [BoltOps Pro subscription](https://boltops.com/pro).

## What's the Difference Between the Community Edition vs Pro?

&nbsp; | Community | Pro
--- | --- | ---
CFN Lifecycle commands | ![](/img/features/yes.svg) | ![](/img/features/yes.svg)
ERB Template Generator | ![](/img/features/yes.svg) | ![](/img/features/yes.svg)
DSL Generator | ![](/img/features/yes.svg) | ![](/img/features/yes.svg)
Reusable Blueprints Structure | ![](/img/features/yes.svg) | ![](/img/features/yes.svg)
Lono Pro Addon: Import and Convert commands | ![](/img/features/no.svg) | ![](/img/features/yes.svg)
Access to BoltOps Pro Blueprints | ![](/img/features/no.svg) | ![](/img/features/yes.svg)

## Lono Pro Addon: Code Import and Convert Commands

Lono features a powerful DSL to build CloudFormation templates. The Lono DSL builds on top of the CloudFormation declarative nature and allows you to write **Infrastructure as Code**. The Lono DSL results in more maintainable code.

Most CloudFormation templates in the wild are written in JSON or YAML though.

The [lono code convert](https://lono.cloud/reference/lono-code-convert/) and [lono code import](https://lono.cloud/reference/lono-code-import/) commands allow you to take JSON or YAML templates and convert it to the Lono DSL code. The conversion process saves you engineering time writing it yourself.

Currently, the lono-pro addon is provided at no cost. In the future, access will be provided to only BoltOps Pro customers.

## What are BoltOps Pro Blueprints?

BoltOps Pro blueprints are reusable CloudFormation templates built and managed by BoltOps.  They are configurable to fit your needs. They are also documented and tested in a daily build process. Essentially, they save you time.

A list of the blueprints is available at: [boltopspro-docs](https://github.com/boltopspro-docs).

## Docs

The docs for both Lono Community Edition and additional Pro features are on [lono.cloud](https://lono.cloud). Pro features are noted accordingly.

{% include prev_next.md %}
