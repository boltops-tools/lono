---
title: lono import
reference: true
---

## Usage

    lono import SOURCE --name=NAME

## Description

Imports raw CloudFormation template and lono-fies it

## Examples

    lono import /path/to/file
    lono import http://url.com/path/to/template.json
    lono import http://url.com/path/to/template.yml

Imports a raw CloudFormation template and lono-fies it.


## Options

```
--name=NAME                  # final name of downloaded template without extension
[--summary], [--no-summary]  # provide template summary after import
                             # Default: true
```

