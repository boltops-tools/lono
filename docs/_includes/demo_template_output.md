```yaml
Description: Demo stack
Parameters:
  InstanceType:
    Default: t3.micro
    Type: String
Mappings:
  AmiMap:
    us-east-1:
      Ami: ami-0de53d8956e8dcf80
    us-west-2:
      Ami: ami-061392db613a6357b
Resources:
  Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType:
        Ref: InstanceType
      ImageId:
        Fn::FindInMap:
        - AmiMap
        - Ref: AWS::Region
        - Ami
      SecurityGroupIds:
      - Fn::GetAtt:
        - SecurityGroup
        - GroupId
      UserData:
        Fn::Base64: |-
          !/bin/bash
          echo hi
  SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: demo security group
Outputs:
  Instance:
    Value:
      Ref: Instance
  SecurityGroup:
    Value:
      Fn::GetAtt:
      - SecurityGroup
      - GroupId
```
