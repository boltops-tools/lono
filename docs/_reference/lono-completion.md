---
title: lono completion
reference: true
---

## Usage

    lono completion *PARAMS

## Description

Prints words for auto-completion.

## Example

    lono completion

Prints words for TAB auto-completion.

## Examples

    lono completion
    lono completion cfn
    lono completion cfn deploy

To enable, TAB auto-completion add the following to your profile:

    eval $(lono completion_script)

Auto-completion example usage:

    lono [TAB]
    lono cfn [TAB]
    lono cfn deploy [TAB]
    lono cfn deploy --[TAB]



