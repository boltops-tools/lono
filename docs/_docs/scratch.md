---
title: Build from Scratch
---

A great way to learn about how lono works is building a project from scratch.  This part of the guide takes you from an empty project to a full working lono project. This will really help you understand the nuts and bolts of working with a lono project.

### Create the directories

```sh
mkdir infra
cd infra
mkdir config
mkdir params
mkdir templates
```

You now have the lono directory structure.

### Create the files

Let's create the initial empty files so we can start working on them.

```sh
touch config/lono.rb
touch params/single_instance.txt
touch templates/instance.yml.erb
```

Those are really the only files needed for a lono project. Now we will add content to the files.

<a id="prev" class="btn btn-basic" href="{% link _docs/tutorial.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/scratch-template-build.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

