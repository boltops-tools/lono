github_url("https://github.com/tongueroo/lono")
linux_image("aws/codebuild/amazonlinux2-x86_64-standard:2.0")
triggers(
  webhook: true,
  filter_groups: [[{type: "EVENT", pattern: "PUSH"}]]
)
