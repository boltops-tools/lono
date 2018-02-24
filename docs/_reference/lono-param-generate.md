---
title: lono param generate
reference: true
---

## Usage

    lono param generate

## Description

generate all parameter files to json format

Example:

To generate a CloudFormation json parameter files in the params folder to the output/params folder.

    lono-params generate

If you have output/params/my-stack.txt. It will generate a CloudFormation json file in output/output/params/my-stack.json.


## Options

```
[--path=PATH]                # Name of the source that maps to the params txt file.  name -> params/NAME.txt.  Use this to override the params/NAME.txt convention
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
[--mute], [--no-mute]        
```

