---
title: Template Helpers
---

Lono provides a few built-in helper methods that help with template processing.  These methods are available in your template views - the files in the `templates` folder.  Here's a list of the common helper methods:

Helper  | Description
------------- | -------------
`partial(name, variables, options)` | Can be use to embed other files in a template.  The partial view should be placed in the `templates/partial` folder of the project.
`partial_exist?(name)` | Checks whether a partial name exist. This can be helpful for writing custom helpers, covered in [Custom Helpers]({% link _docs/custom-helpers.md %})
`indent(text, amount)` | This is a helper method indents the provided string by a specified number of spaces.
`template_s3_path(name)` | This is the s3 path where template gets uploaded to s3 if s3 upload is enabled.
`template_params(name)` | This returns an Array of the parameter values. This is useful in a parent template if you are using nested templates.  You can use this to grab the `params` values and specify the parameters within the parent template.
`user_data(path, vars)`  | Helpful if you are using CloudFormation JSON format. More info on the [wiki page](https://github.com/tongueroo/lono/wiki/user_data-helper-for-json-format).

The full list of helper methods is available here: [lib/lono/template/helpers.rb](https://github.com/tongueroo/lono/blob/master/lib/lono/template/helpers.rb}).

### Partial examples

The partial template helper is very useful and is covered a little more detail here.

* `partial('launch_config')` - Uses the partial in `templates/partial/launch_config`.
* `partial('launch_config', foo: "bar", hello: "world")` - Variables can be passed to the partial helper method are available to the partial as instance variables.  So, in this case `@foo` and `@hello` will be available in the `launch_config` partial.
* `partial('user_data/bootstrap.sh', {}, indent: 10)` - Indent the result partial by 10 spaces.  Useful for yaml format.

Next we'll cover how you add your own custom helpers.

<a id="prev" class="btn btn-basic" href="{% link _docs/layering.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/custom-helpers.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
