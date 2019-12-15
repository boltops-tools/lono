# EC2 Instance Blueprint

Edit `config/params/base/ec2.txt` with your desired parameters.

    InstanceType=t2.micro
    KeyName=default # update with your key

Then launch the stack:

    lono cfn deploy ec2
