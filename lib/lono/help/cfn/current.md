Set current values like stack name and suffix.

{% include current-options.md %}

## Static Example

    lono cfn create demo
    lono cfn current --name demo
    lono cfn update

## Suffix Example

    lono cfn current --suffix random
    lono cfn create demo
    lono cfn update demo-abc # generated random suffix was abc
    lono cfn current --name demo-abc
    lono cfn update
    lono cfn update # update again
