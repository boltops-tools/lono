---
title: Stack Name Suffix
nav_order: 53
---

The `stack_name_suffix` is an option to help with a development workflow. When working with CloudFormation templates and developing the source code, we must often launch stacks repeatedly as we fine tune the stack. Since we cannot launch a stack with a duplicate name it is useful to use a command like this:

    lono cfn create demo-$(date +%s) --blueprint demo

Lono can automatically add a random string to the end of the stack name but use the template name without the random string. The `stack_name_suffix random` option automates this. So we can create multiple stacks with different names but the same source template rapidly.  We can create multiple stacks in rapid-fire fashion and debug.  When the option is set to random:

    lono cfn create demo

Will create a "demo-[RANDOM]" using the demo template name.  The random string is a short 3 character string.

If you prefer not to use a random suffix. You can specify the suffix with the exact name. The value 'random' is treated specially.  Example without random suffix:

    lono cfn create demo --suffix 2
    lono cfn update demo-2 --suffix 2 # --suffix 2 so '-2' gets removed for the template name
    lono cfn update demo-2 --blueprint demo # also works

For non-random suffixes the a natural flow might be to use lono current so you don't have to remember to type --suffix 2. Example:

    lono cfn current --suffix 2
    lono cfn create demo
    lono cfn update demo-2

More info about lono current is available at the [Lono Current docs]({% link _docs/extras/lono-current.md %})

{% include prev_next.md %}
