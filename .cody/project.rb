# For methods, refer to the properties of the CloudFormation CodeBuild::Project https://amzn.to/2UTeNlr
# For convenience methods, refer to the source https://github.com/tongueroo/codebuild/blob/master/lib/codebuild/dsl/project.rb

github_url("https://github.com/boltopspro/bolt.git")
linux_image("aws/codebuild/ruby:2.5.3-1.7.0")

# Uncomment to enable github webhook, the GitHub oauth token needs admin:repo_hook permissions
# Refer to https://github.com/tongueroo/codebuild/blob/master/readme/github_oauth.md
triggers(webhook: true)

# Shorthand to enable all local cache modes
# local_cache(true)
