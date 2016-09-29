# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [0.4.5-dev] Unreleased

- Update use newer ruby syntax.
- Get rid of the core Hash extension that is causing issues with aws-sdk version 2.  I original did this because the output of the generated json files was no deterministic with ruby 1.8.7. No longer supporting ruby 1.8.7.  
- Gem has been tested with ruby 2.2.5+
