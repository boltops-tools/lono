# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [6.0.1]
- #14 restructure dsl methods are available in variables definition
- #15 fix Type camelize bug
- #16 add --variable option, allow user to specify

## [6.0.0]
- #13 DSL improvements: auto camelize off by default
- `auto_camelize: off` as new default for blueprints.
- Old blueprints will continue to auto_camelize unless the `.meta/config.yml` is updated to `auto_camelize: off`
- Upgrade vendor/cfn_status
- Update docs to encourage CamelCase for attributes and properties
- Add and encourage shorthand bang intrinsic methods: `if!`, `not!`, `and!`, `or!`
- Fix iam permission error for `lono cfn preview` command
- Update cli help
- Improve `lono summary` output
- Introduced experimental helpers: `conditional_parameter` and `optional_ref`. Note that their interfaces may change
- Treat common attributes `DependsOn` and `Condition` at the property level specially and move them to the attribute level automatically. Allows for cleaner resource definitions.
- update blueprint starter skeleton

## [5.3.4]
- fix param preview for noecho values that are set

## [5.3.3]
- #12 fix param preview

## [5.3.2]
- #11 enable sse-s3 encryption for lono managed s3 bucket

## [5.3.1]
- #10 fixes for param diff preview: Ignore noecho parameters

## [5.3.0]
- #8 param preview feature. 3rd type of preview.
- #9 ssm helper support in configs
- Simplify param lookup with direct lookup logic.
- Allow params files to have different extensions. Both.txt and .sh work are auto-inferred conventionally.
- Allow condition and depends_on to be a properties level and auto-moved to the attributes level.

## [5.2.8]
- add mfa support for normal IAM user

## [5.2.7]
- hide query string from template_url on display
- update skeleton starter files: Gemfile, starter message, simplify skeleton settings.yml

## [5.2.6]
- reset current dir after lono blueprint new for lono code import command

## [5.2.5]
- #6 updates
- changes so `lono code import` can create full blueprint structure
- improve `lono seed` to prompt before overwriting
- improve starter configs params
- improve started Gemfile
- lono new --demo option to include starter demo blueprint
- lono seed: use Thor::Actions to prompt before overwriting

## [5.2.4]
- add description to lono managed stack

## [5.2.3]
- output dsl: 2nd form allow nil value in case of variables

## [5.2.2]
- seed only support params for main conventional template in blueprint
- set --iam with --sure option also

## [5.2.1]
- improve param lookup

## [5.2.0]
- #5 lono seed command: Lono::Seed::Configs class interface
- add lono cfn cancel command
- content helper
- gracefully handle edge cases with lono s3 bucket
- cleanup classes and modules

## [5.1.1]
- use cfn_camelizer as gem

## [5.1.0]
- change `lono blueprint` to subcommand: `lono blueprint new` and `lono blueprint list` commands
- change `lono configure` to `lono seed`. Seed interface is the same but the path is different: `seed/configs.rb`

## [5.0.1]
- Introduce lono DSL and set as default mode
- Introduce blueprints concept
- Introduce lono cfn deploy command
- Auto-create lono managed s3 bucket
- Zeitwerk autoloader
- Restructure project structure
- Remove aws\_profiles settings.yml in favor of aws_profile
- lono upgrade v4to5 command
- License update: https://www.boltops.com/boltops-community-license

## [4.2.7]
- retain tag values on cfn update operations

## [4.2.6]
- #40 lono cfn create --tags a:1 b:2 option

## [4.2.5]
- use rainbow gem for terminal colors

## [4.2.4]
- bin/release wrapper script

## [4.2.3]
- hide type dot_clean check message

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
