---
title: Build with lono new
---

You do not have to start with an empty folder as your lono project. Normally, you use `lono new my-project` to generate a new lono project with the proper structure.  Example:

```
$ lono new infra
Setting up lono project
creating: infra/config/lono/api.rb
creating: infra/config/lono.rb
creating: infra/Gemfile
creating: infra/Guardfile
creating: infra/params/api-web-prod.txt
creating: infra/params/example.txt
creating: infra/templates/db.yml.erb
creating: infra/templates/example.yml.erb
creating: infra/templates/partial/host_record.yml.erb
creating: infra/templates/partial/server.yml.erb
creating: infra/templates/partial/user_data/bootstrap.sh.erb
creating: infra/templates/web.yml.erb
Starter lono project created
$
```

As you can see `lono new` creates a starter project for you with a few example templates.  This a much quicker way to get up and running!  You can launch the same example that we've used before immediately.

```sh
$ lono cfn create example
```

<a class="btn btn-basic" href="{% link _docs/scratch-cfn-delete.md %}">Back</a>
<a class="btn btn-primary" href="{% link _docs/existing.md %}">Next Step</a>
