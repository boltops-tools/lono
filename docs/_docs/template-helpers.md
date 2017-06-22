---
title: Template Helpers
---

There are helper methods that are available in templates.

Helper  | Description
------------- | -------------
`partial(relative_path, variables, options)`  |Can be use to embed other files in a template.  The partial view should be placed in the `templates/partial` folder of the project.
`user_data`  | Helpful if you are using CloudFormation json format. More info on the [wiki page](https://github.com/tongueroo/lono/wiki/user_data-helper-for-json-format).

Examples of partial:

* `partial('launch_config.json.erb')` - Uses the partial in `templates/partial/launch_config.json.erb`.
* `partial('launch_config.json.erb', foo: "bar", hello: "world")` - Variables can be passed to the partial helper method are available to the partial as instance variables.  So, in this case `@foo` and `@hello` will be available in the `launch_config.json.erb` partial.
* `partial('user_data/bootstrap.sh.erb', {}, indent: 10)` - Indent the result partial by 10 spaces.  Useful for yaml format.

<a id="prev" class="btn btn-basic" href="{% link _docs/conventions.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/organizing-lono.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
