Generates CloudFormation template, parameter files, and scripts in lono project and writes them to the `output` folder.

## Examples

    lono build BLUEPRINT
    lono build BLUEPRINT --clean
    lono g BLUEPRINT --clean # shortcut

## Example Output

    $ lono build ec2
    Building template, parameters, and scripts
    Building template:
      output/templates/ec2.yml
    Building parameters:
      output/params/ec2.json
    $
