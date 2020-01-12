---
title: Lono Current
categories: extras
nav_order: 77
---

Sets current values so you do not have to provide the options repeatedly.  This shortens the commands.

{% include current-options.md %}

## Examples

Create a demo stack and set it as the current stack name.

    lono cfn create demo

The normal update and preview commands are:

    lono cfn update demo
    lono cfn preview demo

Shortened commands:

    lono cfn current --name demo
    lono cfn deploy
    lono cfn update
    lono cfn delete
    lono cfn preview
    lono cfn diff
    lono cfn download
    lono cfn status

The stack name is not longer required because it is set as the current name.

## Remove all settings

To remove all current settings.

    $ lono cfn current --rm
    Current settings have been removed. Removed .lono/current

## Considerations

* The current name setting does not apply to the `lono create` method. The create method requires that you explicitly specify the name: `lono create STACK_NAME`. The create command uses the `--suffix` option only.
* The current name setting applies on commands that refer to existing stacks like update, delete, preview, diff and download.

{% include prev_next.md %}
