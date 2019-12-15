---
title: lono cfn
reference: true
---

## Usage

    lono cfn SUBCOMMAND

## Description

cfn subcommands

## Examples

    lono cfn deploy demo
    lono cfn create demo
    lono cfn preview demo
    lono cfn update demo
    lono cfn delete demo

## Subcommands

* [lono cfn cancel]({% link _reference/lono-cfn-cancel.md %}) - Cancel a CloudFormation stack.
* [lono cfn current]({% link _reference/lono-cfn-current.md %}) - Current stack that you're working with.
* [lono cfn delete]({% link _reference/lono-cfn-delete.md %}) - Delete CloudFormation stack.
* [lono cfn deploy]({% link _reference/lono-cfn-deploy.md %}) - Create or update a CloudFormation stack using the generated template.
* [lono cfn download]({% link _reference/lono-cfn-download.md %}) - Download CloudFormation template from existing stack.
* [lono cfn preview]({% link _reference/lono-cfn-preview.md %}) - Preview a CloudFormation stack update. This is similar to terraform's plan or puppet's dry-run mode.
* [lono cfn status]({% link _reference/lono-cfn-status.md %}) - Shows current status of stack.

## Options

```
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

