---
title: Base64
categories: intrinsic-function
nav_order: 52
---

The `base64` method is the CloudFormation [Fn::Base64](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-base64.html) equivalent.

## Example Snippet

```ruby
resource("Instance", "AWS::EC2::Instance",
  InstanceType: "t3.micro",
  ImageId: "ami-0de53d8956e8dcf80",
  UserData: base64("#!/bin/bash\necho hi")
)
```

## Example Output

```yaml
Resources:
  Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t3.micro
      ImageId: ami-0de53d8956e8dcf80
      UserData:
        Fn::Base64: |-
          #!/bin/bash
          echo hi
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
