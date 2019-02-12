---
title: Params Lookup Locations
nav_order: 47
---

Lono supports param files that look like env files as a simple way to define your CloudFormation run-time parameters.

## Lookup Locations

You can define params files in different locations. Lono lookups up each of these locations until it finds a params file.

{:.lookup-locations}
1. configs/**blueprint**/params/development/**template**/**param**.txt
2. configs/**blueprint**/params/development/**template**.txt
3. configs/**blueprint**/params/development.txt

Depending on how you name your blueprint, templates, and params files, it can greatly simply the configs structure.  Some examples will help explain:

### 1. All Different: blueprint, template, param

Let's say you had a blueprint that defines a different template and uses a different param. For example, the template could be `jenkins` and params could be `large`.  Then you would need the full 1st form which is fully explicit:

    configs/ec2/params/development/jenkins/large.txt

In this case, blueprint, template, and param are all different.  So we require a fully explicit command:

    lono cfn deploy ec2 --template jenkins --param large
    lono cfn deploy myserver --blueprint ec2 --template jenkins --param large

### 2. Only template and param are the same

The 2nd form is when you have the same value for the template and param.  For example, the template and params could both be `jenkins`:

    configs/ec2/params/development/jenkins.txt

In this form the template and param file are the same so can slightly simplify the command:

    lono cfn deploy ec2 --template jenkins
    lono cfn deploy myserver --blueprint ec2 --template jenkins

### 3. All the Same: blueprint, template, param

Let's say the blueprint, template, and param have the same value of `ec2`. This allows you to use the 3rd form.

    configs/ec2/params/development.txt

Thanks to [conventions]({% link _docs/conventions.md %}), the deploy command is greatly simplified:

    lono cfn deploy ec2 # the stack is called ec2
    lono cfn deploy myserver --blueprint ec2 # the stack is called myserver

## Project vs Blueprint Configs

Some blueprints contain starter example params.  When lono is able to find a project param file, it will use that instead of any blueprint example params. Here's an example:

    blueprints/ec2/config/params/development.txt # ignored entirely
    configs/ec2/params/development.txt # will be used

The params in `blueprints` only get used if you have not created one in `configs`.  So the blueprint params will get **ignored**.

If there are no user-defined param `configs`, lono looks through the blueprint's param config folder with the same lookup Locations as detailed above.

{% include prev_next.md %}