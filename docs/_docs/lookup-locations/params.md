---
title: Params Lookup Locations
nav_order: 51
---

Lono supports param files that look like env files as a simple way to define your CloudFormation run-time parameters.

## Lookup Locations

You can define params files in different locations. Lono lookups up each of these locations until it finds a params file.

{:.lookup-locations}
1. configs/**blueprint**/params/development/**param**.txt - Direct Form
2. configs/**blueprint**/params/development/**param**.txt - Direct Env Param
3. configs/**blueprint**/params/**param**.txt -  Direct Simple Param
4. configs/**blueprint**/params/development/**template**/**param**.txt - Conventional Param
5. configs/**blueprint**/params/development/**template**.txt - Conventional Template
6. configs/**blueprint**/params/development.txt - Conventional Env

Depending on how you name your blueprint, templates, and params files, it can greatly simply the configs structure.  Generally, recommend using form #1, #2 and #5.

Here are somme examples to help explain:

### Example 1: Direct Form

The **Direct Form** lookup is the simplest to understand. Let's say you have this param file:

    configs/ec2/params/development/my-params/jenkins/large.txt

You simply specify the path to the param file.

    lono cfn deploy ec2 --template jenkins --param configs/ec2/params/development/my-params/jenkins/large.txt

You can also use absolute paths:

    lono cfn deploy ec2 --template jenkins --param `pwd`/configs/ec2/params/development/my-params/jenkins/large.txt

### Example 2: Direct Env Param

The **Direct Env Param** lookup is also simple. Let's say you have this configs params file:

    configs/ec2/params/development/my-params/jenkins/large.txt

You can just specific the param file with or without the `.txt` extension.

    lono cfn deploy ec2 --template jenkins --param my-params/jenkins/large

You do not need to scope the environment, it's automatically considered.

### Example 3: Direct Simple Param

The **Direct Simple Param***= lookup is also simple. Let's say you have this configs params file:

    configs/ec2/params/my-params/jenkins/large.txt

You can just specific the param file with or without the `.txt` extension.

    lono cfn deploy ec2 --template jenkins --param my-params/jenkins/large

The config file will be found and used. Note, the **Direct Env Param** lookup takes higher precedence than the **Direct Simple Param** lookup.

### Example 4: Conventional Param: All Different: blueprint, template, param

Let's say you had a blueprint that defines a different template and uses a different param. For example, the template could be `jenkins` and params could be `large`.  The **Conventional Param** lookup can handle this.

    configs/ec2/params/development/jenkins/large.txt

In this case, blueprint, template, and param are all different.  So we require a fully explicit command:

    lono cfn deploy ec2 --template jenkins --param large
    lono cfn deploy myserver --blueprint ec2 --template jenkins --param large

### Example 5: Conventional Template: Only template and param are the same

Let's say you have the same value for the template and param.  For example, the template and params could both be `jenkins`. The **Conventional Template** lookup can handle this.

    configs/ec2/params/development/jenkins.txt

In this form the template and param file are the same so can slightly simplify the command:

    lono cfn deploy ec2 --template jenkins
    lono cfn deploy myserver --blueprint ec2 --template jenkins

### Example 6. Conventional Env: All the Same: blueprint, template, param

Let's say the blueprint, template, and param have the same value of `ec2`. This allows you to use the **Conventional Env** form.

    configs/ec2/params/development.txt

Thanks to [conventions]({% link _docs/conventions.md %}), the deploy command is greatly simplified:

    lono cfn deploy ec2 # the stack is called ec2
    lono cfn deploy myserver --blueprint ec2 # the stack is called myserver

{% include prev_next.md %}
