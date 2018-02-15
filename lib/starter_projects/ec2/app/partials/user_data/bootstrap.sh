#!/bin/bash -lexv
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo ${AWS::StackName}  > /tmp/stack_name
cat /proc/uptime | cut -f1 -d'.' > /tmp/time-to-boot
