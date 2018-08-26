# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [4.2.2]
- add vendor files to gem package

## [4.2.1]
- update docs
- fix status tailing check for nested stacks

## [4.2.0]
- lono current
- lono cfn status
- app/files support with file_s3_key helper
- Display status of stack deployment and wait for completion
- fix iam retry logic for cfn update

## [4.1.0]
- Merge pull request #36 from tongueroo/cli_markdown
- fix current_region helper in variables, add s3_region setting
- settings: fix edge cases, nil base, file is empty
- simplify how to set s3 endpoint override so region doesnt have to also be set
- use subshell for extract_scripts

## [4.0.6]
- Update cli docs: generate, import, new, upload
- fix thor description override when command not found

## [4.0.5]
- update lono cfn diff docs

## [4.0.4]
- update lono cfn diff docs
- add S3_REGION env option to configure different s3 client region vs AWS_PROFILE

## [4.0.3]
- update cli docs
- make `--name` option for lono import optional
- simplified template_params helper return structure

## [4.0.2]
- update cli docs

## [4.0.1]
- add http://lono.cloud/reference/
- improve cli docs

## [4.0.0]
- lono upgrade4 command
- simplified lono project structure
- app/scripts upload support and extract_scripts helper
- new settings.yml format: environment support, simplified s3_folder and aws_profiles options
- revamped starter projects
- added focus to lono import flow
- move lono summary up to top-level cli
- cli auto-completion support
- improved YAML parse error: shows error line immediately to user of output template
- better ERB template error rendering with render_me_pretty gem
- remove json support. focus on yaml.
- lono user_data command

## [3.5.0]
- Using Lono.root instead of scattered project_root parameters
- prefer use of Lono.env over LONO_ENV internally
- do not remove blank lines from the generated template, it makes user-data scripts harder to read
- remove adding of extra line to partials, causing issues with user data partials

## [3.4.1]
- docs for lono settings

## [3.4.0]
- fix lono project config settings
- upgrade to circleci 2.0
- add current_region helper
- update install notes

## [3.3.4]
- require specific aws-sdk s3 and cloudformation dependencies to reduce size

## [3.3.3]
- lono import also creates a params/base file

## [3.3.2]
- remove -prod from the starter project

## [3.3.1]
- update lono inspect summary help

## [3.3.0]
- add lono inspect summary
- remove lono inspect params

## [3.2.1]
- fix lono inspect params

## [3.2.0]
- lono inspect depends
- lono inspect params

## [3.1.3]
- fix randomize stack name option

## [3.1.2]
- lono import: casing option: camelcase or dasherize

## [3.1.1]
- update lono import and new cli help

## [3.1.0]
- lono import command

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
- Setting File Support

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
