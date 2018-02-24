---
title: lono user_data
reference: true
---

## Usage

    lono user_data NAME

## Description

Generates user_data script for debugging

Generates user_data scripts in `app/user_data` so you can see it for debugging. Let's say you have a script in `app/user_data/bootstrap.sh`. To generate it:

    lono user_data bootstrap


## Options

```
[--clean], [--no-clean]  # remove all output/user_data files before generating
                         # Default: true
```

