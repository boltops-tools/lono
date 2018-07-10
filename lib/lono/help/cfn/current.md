Set current values like stack name and suffix.

## Static Suffix Example

    lono cfn current --name demo-2 --suffix 2
    lono cfn create demo
    lono cfn update

## Random Suffix Example

    lono cfn current --suffix random
    lono cfn create demo
    lono cfn update demo-abc # generated random suffix was abc
    lono cfn current --name demo-abc
    lono cfn update
    lono cfn update # update again
