## Example

    $ lono sets instances delete my-set --accounts 112233445566 --regions us-west-1 us-west-2
    Are you sure you want to delete the my-set instances?
    These stack instances will be deleted:

        accounts: 112233445566
        regions: us-west-1,us-west-2


    Are you sure? (y/N) y
    Stack Instance statuses... (takes a while)
    Stack Instance: account 112233445566 region us-west-1 status CURRENT
    Stack Instance: account 112233445566 region us-west-2 status CURRENT
    Stack Instance: account 112233445566 region us-west-2 status OUTDATED reason User initiated operation
    Stack Instance: account 112233445566 region us-west-1 status OUTDATED reason User initiated operation
    Stack Instance: account 112233445566 region us-west-1 status DELETED
    Stack Instance: account 112233445566 region us-west-2 status DELETED
    Time took to complete stack set operation: 30s
    Stack set operation completed.
    $