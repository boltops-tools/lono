---
title: Shared Variables
---

### Template Shared Variables

Template shared variables are available to all template config blocks and template views.  These variables are defined in the `config/variables` folder.  The variables files are simply ruby scripts where any instance variable (variables with an @ sign in front) is made available.

Here's an example:

`config/variables/base/variables.rb`:

```ruby
@ami = "ami-base"
```

The `@ami` variable is now available to all of your templates.  Effective use of shared variables can dramatically shorten down your template declarations.  Variables are also layered by lono which is covered in [Layering Support]({% link _docs/layering.md %}).

<a id="prev" class="btn btn-basic" href="{% link _docs/config-templates.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/params.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
