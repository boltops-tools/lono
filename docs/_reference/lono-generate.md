---
title: lono generate
reference: true
---

## Usage

    lono generate BLUEPRINT

## Description

Generate both CloudFormation templates and parameters files.

Generates CloudFormation template, parameter files, and scripts in lono project and writes them to the `output` folder.

## Examples

    lono generate BLUEPRINT
    lono generate BLUEPRINT --clean
    lono g BLUEPRINT --clean # shortcut

## Example Output

    $ lono generate ec2
    Generating CloudFormation templates, parameters, and scripts
    Generating CloudFormation templates:
      output/templates/ec2.yml
    Generating parameter files:
      output/params/ec2.json
    $


## Options

```
[--quiet], [--no-quiet]  # silence the output
[--clean], [--no-clean]  # remove all output files before generating
                         # Default: true
[--source=SOURCE]        # url or path to file with template
[--stack=STACK]          # stack name. defaults to blueprint name.
[--template=TEMPLATE]    # override convention and specify the template file to use
[--param=PARAM]          # override convention and specify the param file to use
[--variable=VARIABLE]    # override convention and specify the variable file to use

Runtime options:
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

