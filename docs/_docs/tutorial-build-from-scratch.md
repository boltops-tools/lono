---
title: Build from Scratch
---

A great way to learn how lono works is by building a project from scratch.  This part of the guide takes you from an empty folder to a fully working lono project. This will really help you understand the [nuts and bolts](http://blog.boltops.com) of working with a lono project.

### Create the directories

```sh
mkdir infra
cd infra
mkdir -p config/templates/base
mkdir -p config/variables/base
mkdir -p params/base
mkdir templates
```

You now have a barebones lono directory structure.

### Create the files

Let's create the initial empty files so we can start working on them.

```sh
touch config/templates/base/stacks.rb
touch config/variables/base/variables.rb
touch params/base/single_instance.txt
touch templates/instance.yml.erb
```

Those are the only files needed for a lono project. Next we will add content to the files.

<a id="prev" class="btn btn-basic" href="{% link _docs/tutorial.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorial-template-build.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

