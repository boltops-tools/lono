Displays code diff of the generated CloudFormation template locally vs the existing template on AWS. You can set a desired diff viewer by setting the `LONO_DIFF` environment variable.

## Examples

    $ lono cfn diff ec2
    Using template: output/templates/ec2.yml
    Using parameters: config/params/development/ec2.txt
    No detected app/scripts
    Generating CloudFormation templates:
      output/templates/ec2.yml
      output/params/ec2.json
    Generating CloudFormation source code diff...
    Running: colordiff /tmp/existing_cfn_template.yml output/templates/ec2.yml
    19c19
    <     Default: t2.small
    ---
    >     Default: t2.medium
    $ subl -a ~/.lono/settings.yml
    $

Here's a screenshot of the output with the colored diff:

<img src="/img/reference/lono-cfn-diff.png" alt="Stack Update" class="doc-photo">

A `lono cfn diff` is perform automatically as part of `lono cfn update`.
