---
title: Quick Start
nav_order: 1
---

In a hurry? No problem!  Here's a quick start to using lono that takes only a few minutes.  The commands below launches a CloudFormation stack with an EC2 Instance and Security Group.

    gem install lono
    lono new infra
    cd infra
    lono cfn deploy demo

Congratulations!  You have successfully created a CloudFormation stack with lono. It's that simple. 😁

## What Just Happened?

Here's a little more details to help understand what happened. We first installed lono and generated a new lono project called `infra`:

    $ gem install lono
    $ lono new infra
    => Creating new project called infra.
    => Creating new blueprint called demo.
    => Initialize git repo
    => Installing dependencies with: bundle install
    Congrats  You have successfully created a lono project.  A starter demo blueprint was created
    and is at blueprints/demo.  Check things out by going into the created infra folder.

      cd infra

    To generate the blueprint templates without launching a stack, you can run:

      lono generate demo

    The generated files are created at `output/demo/templates` and `output/demo/params`.

    To deploy the CloudFormation stack:

      lono cfn deploy my-demo --blueprint demo

    If you name the stack according to conventions, you can simply run:

      lono cfn deploy demo

    To list and create additional blueprints refer to http://lono.cloud/docs/blueprints

    More info: http://lono.cloud/

Then we went into the `infra` project folder and deployed the demo stack:

    $ cd infra
    $ lono cfn deploy demo

The command `lono cfn deploy demo` does a few things:

1. Generate templates and params files using the blueprint in `blueprints/demo`.
2. The templates and parameters files are written to `output/demo/templates` and `output/demo/params`.
3. Launches the CloudFormation stack.

The example launches an EC2 instance with a security group. Check out the newly launch stack in the AWS console:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

{% include prev_next.md %}
