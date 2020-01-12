## UserData cfn-init

You can make sure configsets are applied by calling the cfn-init script in the UserData script. The UserData script runs when EC2 instances are launched.  Here's an example UserData script.

```bash
#!/bin/bash
yum install -y aws-cfn-bootstrap # install cfn-init
/opt/aws/bin/cfn-init -v --stack ${AWS::StackName} --resource Instance --region ${AWS::Region}
```

The `${AWS::StackName}` and `${AWS::Region}` will be substituted for their actual values at CloudFormation runtime.  The `--resource Instance` specifies which resource to add the configsets to.

Note: On AmazonLinux2 cfn-init is already installed.
