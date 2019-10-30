---
title: lono completion_script
reference: true
---

## Usage

    lono completion_script

## Description

Generates a script that can be eval to setup auto-completion.

To use, add the following to your `~/.bashrc` or `~/.profile`:

    eval $(lono completion_script)


## Options

```
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

