# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [7.5.2] - 2022-02-08
- [#74](https://github.com/boltops-tools/lono/pull/74) activesupport require fix
- fix activesupport require

## [7.5.1] - 2021-05-03
- remove registration check
- fix brew install graphviz message

## [7.5.0]
- #71 `set_instances deploy` command in favor of `set_instances sync`

## [7.4.11]
- fix lookup_output

## [7.4.10]
- #70 fix out-of-sync Gemfile.lock

## [7.4.9]
- #69 `stack_output` and `stack_resource` helpers

## [7.4.8]
- #68 squeezer: auto clean empty array values
- add version numbers to extension gemspec template to remove deprecations

## [7.4.7]
- #65 soft lono deprecations: `lono_type` must be set in gemspec
- #66 fix configset s3_key, s3 endpoint is specially treated for us-east-1
- #67 fix materializer for multiple extensions

## [7.4.6]
- #64 lono new updates: no starter seed files, allow custom readme
- silence type check

## [7.4.5]
- add DeletionPolicy to special property mover also
- improve sets delete messaging

## [7.4.4]
- #62 update gemspec templates
- #63 lono sets: default --iam option to true for stack sets

## [7.4.3]
- #61 clean install fixes
- improve tree detection
- improve colordiff detection
- improve AWS setup detection
- remove bundler install for blueprint, extension, and configsets

## [7.4.2]
- #60 fix edge case when cached materialized Gemfile.lock breaks finder

## [7.4.1]
- #59 lono generate fix: generate with configsets

## [7.4.0]
- #57 Big improvements generally and configsets
- #58 Docs: Configsets and new DSL Helpers

## [7.3.2]
- #56 build lambda layer fix: allow Gemfile.lock to be generated if not provided

## [7.3.1]
- #55 lambda layer fixes: allow Gemfile path option to vendor gems

## [7.3.0]
- #54 introduce lambda layer concept

## [7.2.3]
- #53 improve configset lookup path lookup
- cleanup starter blueprint

## [7.2.2]
- #52 configset: content_file helper

## [7.2.1]
- #51 fix extensions helpers loading and cleanup

## [7.2.0]
- #48 fix codebuild and circleci
- #49 lono extensions
- #50 lono extensions docs

## [7.1.0]
- #42 introduce configset dsl
- #43 improve layering behavior
- #44 metadata fixes:  lono_strategy
- #45 lono_type fix
- #46 require bundler 2 at least: fixes Gemfile.lock generation
- #47 use with_unbundled_env

## [7.0.5]
- #41 sort parameter with required at top

## [7.0.4]
- #40 fix lono summary total

## [7.0.3]
- #39 improve param parser. allow surrounding quotes

## [7.0.2]
- fix build and improve docs
- improve reg check message

## [7.0.1]
- #37 allow Conditional to work with no camelized keys
- #38 prevent YAML.dump from emitting aliases

## [7.0.0]
- #36 lono v7
- Breaking: project `blueprints` moved to `app/blueprints`. Use `lono upgrade` to update.
- Introduce configsets concept.
- Introduce lono sets concept: `lono sets`, `lono sets deploy`, `lono set_instances sync`
- Merge lono-pro into lono. Deprecate lono-pro gem.
- Add lono registration.
- Major refactoring:
- Remove stack name suffix option
- Remove current concept
- Introduce Lono::AbstractBase class
- Pass CLI options consistently straight through.
- Use Lono::Conventions.
- Introduce Lono::Cfn::Opts to remove duplication
- Internally use `@stack` instead of `@stack_name`. `@stack` can be either a stack or stack_set

## [6.1.11]
- #35 fix app files variables erb lookup scope

## [6.1.10]
- #32 use lono dsl scope for the app files erb processing
- #33 fix squeezer for Array. squeeze hashes nested in arrays too
- #34 fix squeeze for false values

## [6.1.9]
- #30 fix md5 sum calcuation for single file
- #31 Add app files ERB support docs
- options `--sure` and `--iam` add `CAPABILITY_AUTO_EXPAND` for serverless transform

## [6.1.8]
- #28 add user_data_script helper
- #29 remove items in Hash structure with nil value at any level

## [6.1.7]
- #25 add stack_name helper
- #26 ref Split: true option
- #27 fix ref Split: true option

## [6.1.6]
- #24 auto remove properties with nil value
- lono seed: change default optional value to nothing

## [6.1.5]
- #23 improve blueprint starter project and add --no-demo option

## [6.1.4]
- #22 tags helper: return nil if @tags not set and using variable mode

## [6.1.3]
- #21 smarter tags helper. use @tags variable if tags called without arguments

## [6.1.2]
- #20 improve param Conditional form with 3rd form

## [6.1.1]
- #19 fix param Conditional option

## [6.1.0]
- #17 big improvements to how the configs lookup logic happens: simpler and easier to understand
- variables lookup strategy is same as params
- `--config` option sets both `--param` and `--variable`
- also account for stack name as part of conventional lookup - big win to help provide consistent and organized configs files.
- #18 parameter(name, Conditional: true)
- ref(name, Conditional: true)
- deprecated `conditional_parameter`, `optional_ref`
- deprecated `tags` helper, use `tag_list` instead
- cleanup: organize CoreHelper

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
- add https://lono.cloud/reference/
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
