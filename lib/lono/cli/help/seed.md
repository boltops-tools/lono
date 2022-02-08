## Example

    $ lono seed ecs-asg
    Creating starter config files for ecs-asg
          create  config/ecs-asg/params/development.txt
    $ cat config/ecs-asg/params/development.txt
    # Required parameters:
    VpcId=vpc-111 # Find at vpc CloudFormation Outputs
    Subnets=subnet-111,subnet-222,subnet-333 # Find at vpc CloudFormation Outputs
    # Optional parameters:
    # InstanceType=m5.large
    # KeyName=...
    # SshLocation=...
    # EcsCluster=development
    # TagName=ecs-asg-development
    # ExistingIamInstanceProfile=...
    # ExistingSecurityGroups=...
    # EbsVolumeSize=50
    # MinSize=1
    # MaxSize=4
    # MinInstancesInService=2
    # MaxBatchSize=1
    $