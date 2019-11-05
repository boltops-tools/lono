---
title: Quick Start
nav_order: 1
---

<div class="video-box"><div class="video-container"><iframe src="https://www.youtube.com/embed/hOx6NrBzNnY" frameborder="0" allowfullscreen=""></iframe></div></div>

In a hurry? No problem!  Here's a quick start to using lono that takes only a few minutes.

    gem install lono

Now we're ready to create and launch some infrastructure. The commands below launches a CloudFormation stack with an EC2 Instance and Security Group.

    lono new infra
    cd infra
    lono blueprint new demo
    lono cfn deploy demo

Congratulations!  You have successfully created a CloudFormation stack with lono. It's that simple. 😁

## What Just Happened?

Here's a little more details to help understand what happened. We first installed lono and generated a new lono project called `infra`:

    $ lono new infra
    => Creating new project called infra.
    => Creating new blueprint called demo.
    => Initialize git repo
    => Installing dependencies with: bundle install
    Congrats  You have successfully created a lono project.  A starter demo blueprint was created
    and is at blueprints/demo.  Check things out by going into the created infra folder.

        cd infra

    To create a new blueprint run:

        lono blueprint new demo

    To deploy the blueprint:

        lono cfn deploy my-demo --blueprint demo

    If you name the stack according to conventions, you can simply run:

        lono cfn deploy demo

    To list and create additional blueprints refer to https://lono.cloud/docs/core/blueprints

    More info: http://lono.cloud/
    $

Then we went into the `infra` project folder, created a blueprint, and deployed the demo stack:

    lono blueprint new demo
    lono cfn deploy demo

The command `lono cfn deploy demo` does a few things:

1. Generate templates and params files using the blueprint in `blueprints/demo`.
2. The templates and parameters files are written to `output/demo/templates` and `output/demo/params`.
3. Launches the CloudFormation stack.

The example launches an EC2 instance with a security group. Check out the newly launch stack in the AWS console:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

{% include prev_next.md %}
