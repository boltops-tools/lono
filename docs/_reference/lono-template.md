---
title: lono template
reference: true
---

## Usage

    lono template SUBCOMMAND

## Description

template subcommands

## Examples

    lono template generate --help
    lono template bashify --help

## Subcommands

* [lono template bashify]({% link _reference/lono-template-bashify.md %}) - Convert the UserData section of an existing CloudFormation Template to a starter bash script that is compatiable with lono
* [lono template generate]({% link _reference/lono-template-generate.md %}) - Generate the CloudFormation templates
* [lono template upload]({% link _reference/lono-template-upload.md %}) - Uploads templates to configured s3 folder

## Options

```
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

