---
title: lono code import
reference: true
---

## Usage

    lono code import SOURCE

## Description

Imports CloudFormation template and converts it to different lono formats.

## Example

    lono code import path/to/file


## Options

```
[--blueprint=BLUEPRINT]                        # final blueprint name
[--casing=CASING]                              # Controls casing of logical ids. IE: as-is, camelcase or underscore
                                               # Default: as-is
[--summary], [--no-summary]                    # provide template summary after import
                                               # Default: true
[--template=TEMPLATE]                          # final template name of downloaded template without extension
[--template-name-casing=TEMPLATE_NAME_CASING]  # camelcase or dasherize the template name
                                               # Default: dasherize
[--type=TYPE]                                  # import as a DSL or ERB template
                                               # Default: dsl
```
