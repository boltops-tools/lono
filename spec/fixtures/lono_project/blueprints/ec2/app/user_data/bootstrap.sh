#!/bin/bash
set -x
echo ${AWS::StackName}  > /tmp/stack_name
cat /proc/uptime | cut -f1 -d'.' > /tmp/time-to-boot
