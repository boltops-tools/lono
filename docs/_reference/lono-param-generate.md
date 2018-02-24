---
title: lono param generate
---

## Usage

    lono param generate

## Summary

generate all parameter files to json format
## Description

Example:

To generate a CloudFormation json parameter files in the params folder to the output/params folder.

    lono-params generate

If you have params/my-stack.txt. It will generate a CloudFormation json file in output/params/my-stack.json.


## Options

```
[--path=PATH]                # Name of the source that maps to the params txt file.  name -> params/NAME.txt.  Use this to override the params/NAME.txt convention
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
[--mute], [--no-mute]        
```

