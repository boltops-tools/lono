---
title: lono generate
---

## Usage

    lono generate

## Summary

Generate both CloudFormation templates and parameters files
## Description

Examples:

    lono generate
    lono generate --clean
    lono g --clean # shortcut

Builds both CloudFormation template and parameter files based on lono project and writes them to the output folder on the filesystem.


## Options

```
[--clean], [--no-clean]  # remove all output files before generating
                         # Default: true
[--quiet], [--no-quiet]  # silence the output
```

