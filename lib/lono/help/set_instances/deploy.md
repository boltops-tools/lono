The deploy command delegates to the `lono set_instances create` or `lono set_instances update` commands. This spares you from having to manually figuring out which stack instances need to be created and updated.

## Example

    $ lono set_instances deploy enable-aws-config --accounts 111111111111 222222222222 --regions us-west-2 us-east-2Running lono set_instances create on account: 111111111111 regions: us-west-2,us-east-2
    Deploying enable-aws-config stack set
    Stack Set Operation Status: RUNNING
    Stack Instance statuses... (takes a while)
    You can also check with StackSets console at the Operations Tab.
    Here is also the cli command to check:

        aws cloudformation describe-stack-set-operation --stack-set-name enable-aws-config --operation-id 44a50065-1b10-49f0-b6b9-853092a0cb09

    2020-04-25 10:58:32PM Stack Instance: account 222222222222 region us-east-2 status CURRENT
    2020-04-25 10:58:32PM Stack Instance: account 111111111111 region us-west-2 status OUTDATED reason User initiated operation
    2020-04-25 10:58:32PM Stack Instance: account 222222222222 region us-west-2 status CURRENT
    2020-04-25 10:58:32PM Stack Instance: account 111111111111 region us-east-2 status OUTDATED reason User initiated operation
    Stack Set Operation Status: SUCCEEDED
    Time took to complete stack set operation: 1m 23s
    Stack Set Operation Summary:
    account 111111111111 region us-west-2 status SUCCEEDED
    account 111111111111 region us-east-2 status SUCCEEDED
    Running lono set_instances update on account: 222222222222 regions: us-west-2,us-east-2
    Deploying enable-aws-config stack set
    Stack Set Operation Status: RUNNING
    Stack Set Operation Status: SUCCEEDED
    Time took to complete stack set operation: 23s
    Stack Set Operation Summary:
    account 222222222222 region us-west-2 status SUCCEEDED
    account 222222222222 region us-east-2 status SUCCEEDED
    $