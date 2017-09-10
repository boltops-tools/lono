# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [3.0.1]
- update aws-sdk to version 3

## [3.0.0]
- Major feature changes
- Lono structural changes
- Layering Support
- Shared Variable Support
- Nested Stacks Support
- Format and Extension Detection
- Custom Helper Support
- Source Name Convention Support
- Settings File Support

## [2.1.0]
- improve instance_eval error when lono.rb errors, print out line of code and context

## [2.0.5]
- add example template to starter app
- add docs website

## [2.0.4]
- cfn preview: exit gracefully when stack doesnt exist
- exit gracefully with ctrl-c

## [2.0.3]
- fix param generation with cfn preview when stack name is different from param name

## [2.0.2]
- fix starter project param files

## [2.0.1]
- fix lono cfn update

## [2.0.0]
- added lono cfn subcommand to launch CloudFormation stacks
- added lono params subcommand to generate CloudFormation parameter files
- moved lono template methods into subcommand.  lono generate still available at top level.

## [1.1.4]
- allow --help or -h at the end of the command

## [1.1.3]
- make display output path prettier

## [1.1.2]
- erb error fix context off by 1

## [1.1.1]
- default detected format to yaml if no templates defined yet

## [1.1.0]
- useful ERB render error messages

## [1.0.2]
- remove blank lines from yaml output

## [1.0.1]
- update starter project instance type allowed values

## [1.0.0]
- Yaml support added!  Makes for much more clean and concise templates.  The `lono new` command defaults to yaml format.
- The starter project is app centric instead of env centric.  Example: blog-web-prod vs prod-blog-web.

## [0.5.2]
- Add helper encode_base64 method in case you want to base64 encode a string in the ERB template and you are using lono outside of the context of CloudFormation where you will not have access to the FN::Base64 Function.

## [0.5.1]
- move ensure_dir up above validation so folder gets created even with bad json.  fixes #14

## [0.5.0]

- Update use newer ruby syntax.
- Get rid of the core Hash extension that is causing issues with aws-sdk version 2.  I original did this because the output of the generated json files was no deterministic with ruby 1.8.7. No longer supporting ruby 1.8.7.
- Gem has been tested with ruby 2.2.5+
