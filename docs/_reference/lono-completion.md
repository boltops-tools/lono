---
title: lono completion
reference: true
---

## Usage

    lono completion *PARAMS

## Summary

prints words for auto-completion

## Description

Example:

    lono completion

Prints words for TAB auto-completion.

Examples:

    lono completion
    lono completion hello
    lono completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(lono completion script)

Auto-completion example usage:

    lono [TAB]
    lono hello [TAB]
    lono hello name [TAB]
    lono hello name --[TAB]



