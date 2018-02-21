---
title: Directory Structure
---

A basic lono project usually looks something like this:

```sh
.
├── config
│   ├── templates
│   │   ├── base
│   │   │   └── stacks.rb
│   │   ├── prod
│   │   │   └── stacks.rb
│   │   └── stag
│   │       └── stacks.rb
│   └── variables
│       ├── base
│       │   └── variables.rb
│       ├── prod
│       │   └── variables.rb
│       └── stag
│           └── variables.rb
├── helpers
│   └── my_custom_helper.rb
├── output
├── params
│   ├── base
│   │   └── example.txt
│   ├── prod
│   │   └── example.txt
│   └── stag
│       └── example.txt
└── templates
    ├── db.yml
    ├── example.yml
    ├── partial
    │   ├── host_record.yml
    │   ├── server.yml
    │   └── user_data
    │       └── bootstrap.sh
    └── web.yml
```

{% include structure.md %}

That should give you a basic feel for the lono directory structure.

<a id="prev" class="btn btn-basic" href="{% link _docs/components.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/lono-env.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
