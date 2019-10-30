---
title: lono script
reference: true
---

## Usage

    lono script SUBCOMMAND

## Description

script subcommands

## Subcommands

* [lono script build]({% link _reference/lono-script-build.md %}) - Builds `output/scripts/scripts-md5sum.tgz` from `app/script` folder
* [lono script upload]({% link _reference/lono-script-upload.md %}) - Uploads `output/scripts/scripts-md5sum.tgz` to s3

## Options

```
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

