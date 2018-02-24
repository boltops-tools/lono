## Examples

Provided that you are in a lono project and have a `my-stack` lono template definition.  To update a stack you can simply run:

  lono cfn update my-stack

The above command will generate and use the template in `output/templates/my-stack.json` and parameters in `output/params/my-stack.txt`.  The template by convention defaults to the name of the stack.  In turn, the params by convention defaults to the name of the template.

Here are examples of overriding the template and params name conventions.

  lono cfn update my-stack --template different1

The template used is `output/templates/different1.json` and the parameters used is `output/params/different1.json`.

  lono cfn update my-stack --params different2

The template used is `output/templates/my-stack.json` and the parameters used is `output/params/different2.json`.

  lono cfn update my-stack --template different3 --params different4

The template used is `output/templates/different3.json` and the parameters used is `output/params/different4.json`.
