---
title: lono sets deploy
reference: true
---

## Usage

    lono sets deploy STACK_SET

## Description

Deploy CloudFormation stack set.

## Example

    $ lono sets deploy my-set --blueprint demo
    Generating CloudFormation templates for blueprint demo:
      output/demo/templates/demo.yml
    Uploading CloudFormation templates...
    Uploaded: output/demo/templates/demo.yml to s3://lono-bucket-12di8xz5sy72z/development/output/demo/templates/demo.yml
    Templates uploaded to s3.
    Generating parameter files for blueprint demo:
    Using params for development: configs/demo/params/development.txt
      output/demo/params/development.json
    Parameter Diff Preview:
    Running: colordiff /tmp/lono/params-preview/existing.json /tmp/lono/params-preview/new.json
    There were no differences.
    Generating CloudFormation source code diff...
    Running: colordiff /tmp/existing_stack_set.yml /home/ec2-user/environment/infra/output/demo/templates/demo.yml
    33c33
    <         Value: '2019-12-19 22:46:33 +0000'
    ---
    >         Value: '2019-12-19 23:08:05 +0000'
    Parameters passed to cfn.update_stack_set:
    ---
    stack_set_name: my-set
    parameters:
    - parameter_key: GroupDescription
      parameter_value: my-group-description-1
    template_url: https://lono-bucket-12di8xz5sy72z.s3.us-west-2.amazonaws.com/development/output/demo/templates/demo.yml
    template_body: 'Hidden due to size... View at: output/demo/templates/demo.yml'
    Are you sure you want to update the my-set stack set?
    Will deploy to:
      account: 112233445566
      regions: ap-northeast-1,ap-northeast-2,us-west-1,us-west-2
      account: 223344556677
      regions: ap-northeast-1,ap-northeast-2,us-west-1,us-west-2

    Number of stack instances to be updated: 8
    Are you sure? (y/N) y
    Updating my-set stack set
    Stack Set Operation Status: RUNNING
    Stack Instance statuses... (takes a while)
    2019-12-19 11:08:21 PM Stack Instance: account 112233445566 region ap-northeast-1 status OUTDATED reason User initiated operation
    2019-12-19 11:08:21 PM Stack Instance: account 112233445566 region us-west-2 status OUTDATED reason User initiated operation
    2019-12-19 11:08:23 PM Stack Instance: account 112233445566 region ap-northeast-2 status OUTDATED reason User initiated operation
    2019-12-19 11:08:30 PM Stack Instance: account 223344556677 region ap-northeast-1 status OUTDATED reason User initiated operation
    2019-12-19 11:08:30 PM Stack Instance: account 223344556677 region ap-northeast-2 status OUTDATED reason User initiated operation
    2019-12-19 11:08:30 PM Stack Instance: account 112233445566 region us-west-1 status OUTDATED reason User initiated operation
    2019-12-19 11:08:30 PM Stack Instance: account 223344556677 region us-west-1 status OUTDATED reason User Initiated
    2019-12-19 11:08:31 PM Stack Instance: account 223344556677 region us-west-2 status OUTDATED reason User initiated operation
    2019-12-19 11:08:49 PM Stack Instance: account 223344556677 region us-west-1 status CURRENT
    2019-12-19 11:08:58 PM Stack Instance: account 112233445566 region us-west-1 status OUTDATED reason User Initiated
    2019-12-19 11:09:17 PM Stack Instance: account 112233445566 region us-west-1 status CURRENT
    2019-12-19 11:09:28 PM Stack Instance: account 112233445566 region ap-northeast-2 status OUTDATED reason User Initiated
    2019-12-19 11:09:51 PM Stack Instance: account 112233445566 region ap-northeast-2 status CURRENT
    2019-12-19 11:10:03 PM Stack Instance: account 223344556677 region ap-northeast-2 status OUTDATED reason User Initiated
    2019-12-19 11:10:27 PM Stack Instance: account 223344556677 region ap-northeast-2 status CURRENT
    2019-12-19 11:10:36 PM Stack Instance: account 112233445566 region ap-northeast-1 status OUTDATED reason User Initiated
    2019-12-19 11:10:59 PM Stack Instance: account 112233445566 region ap-northeast-1 status CURRENT
    2019-12-19 11:11:08 PM Stack Instance: account 223344556677 region ap-northeast-1 status OUTDATED
    2019-12-19 11:11:13 PM Stack Instance: account 223344556677 region ap-northeast-1 status OUTDATED reason User Initiated
    2019-12-19 11:11:36 PM Stack Instance: account 223344556677 region ap-northeast-1 status CURRENT
    2019-12-19 11:11:46 PM Stack Instance: account 112233445566 region us-west-2 status OUTDATED reason User Initiated
    2019-12-19 11:12:09 PM Stack Instance: account 112233445566 region us-west-2 status CURRENT
    2019-12-19 11:12:19 PM Stack Instance: account 223344556677 region us-west-2 status OUTDATED reason User Initiated
    Stack Set Operation Status: SUCCEEDED
    2019-12-19 11:12:42 PM Stack Instance: account 223344556677 region us-west-2 status CURRENT
    Time took to complete stack set operation: 4m 29s
    Stack Set Operation Summary:
    account 223344556677 region us-west-1 status SUCCEEDED
    account 112233445566 region us-west-2 status SUCCEEDED
    account 112233445566 region ap-northeast-1 status SUCCEEDED
    account 112233445566 region ap-northeast-2 status SUCCEEDED
    account 223344556677 region ap-northeast-2 status SUCCEEDED
    account 223344556677 region us-west-2 status SUCCEEDED
    account 112233445566 region us-west-1 status SUCCEEDED
    account 223344556677 region ap-northeast-1 status SUCCEEDED
    demo


## Options

```
    [--rollback], [--no-rollback]                    # rollback
                                                     # Default: true
    [--source=SOURCE]                                # url or path to file with template
    [--blueprint=BLUEPRINT]                          # override convention and specify the template file to use
    [--capabilities=one two three]                   # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
c, [--config=CONFIG]                                 # override convention and specify both the param and variable file to use
    [--iam], [--no-iam]                              # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
p, [--param=PARAM]                                   # override convention and specify the param file to use
    [--tags=key:value]                               # Tags for the stack. IE: Name:api-web Owner:bob
    [--template=TEMPLATE]                            # override convention and specify the template file to use
v, [--variable=VARIABLE]                             # override convention and specify the variable file to use
    [--change-set], [--no-change-set]                # Uses generated change set to update the stack.  If false, will perform normal update-stack.
                                                     # Default: true
    [--changeset-preview], [--no-changeset-preview]  # Show ChangeSet changes preview.
                                                     # Default: true
    [--codediff-preview], [--no-codediff-preview]    # Show codediff changes preview.
                                                     # Default: true
    [--param-preview], [--no-param-preview]          # Show parameter diff preview.
                                                     # Default: true
    [--wait], [--no-wait]                            # Wait for stack operation to complete.
                                                     # Default: true
    [--sure], [--no-sure]                            # Skip are you sure prompt
    [--region-order=one two three]                   # region_order
    [--failure-tolerance-count=N]                    # failure_tolerance_count
    [--failure-tolerance-percentage=N]               # failure_tolerance_percentage
    [--max-concurrent-count=N]                       # max_concurrent_count
    [--max-concurrent-percentage=N]                  # max_concurrent_percentage
```

