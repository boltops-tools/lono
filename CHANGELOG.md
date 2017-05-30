# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

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
