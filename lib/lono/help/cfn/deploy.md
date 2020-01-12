The `cfn deploy` command figures out whether or not it should perform a stack create or update. It delegates to `cfn create` or `cfn update`.  This saves you from thinking about it

## Examples

Provided that you are in a lono project and have a `demo` lono blueprint that contains a `demo` template.  To create a stack you can run:

    lono cfn deploy demo

The above command will generate:

* template:   output/demo/templates/demo.yml
* parameters: output/demo/params/development.json


## Conventions

By [convention]({% link _docs/conventions/cli.md %}), the blueprint name is the same as the stack name. In turn, template name is the same as the blueprint name. Lastly, the param name will match the stack name unless it's explicitly specified with `--config` or `--param`.

Often you want to create a stack name that is different from the blueprint name. Here’s an example of overriding the blueprint name.

    lono cfn deploy my-stack --blueprint demo