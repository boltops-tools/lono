#!/bin/bash -lexv
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

FIND_IN_MAP=<%= find_in_map("MapName", "TopLevelKey", "SecondLevelKey") %>
HOSTNAME_PREFIX=<%= find_in_map("EnvironmentMapping", "HostnamePrefix", ref("Environment")) %>
BAR=<%= ref("DRINK") %> ; MORE=<%= find_in_map("MapName", "TopLevelKey", "SecondLevelKey") %>

BASE64=<%= base64("value to encode") %>
GET_ATT=<%= get_att("server", "PublicDnsName") %>
GET_AZS=<%= get_azs %>
JOIN=<%= join(":", ['a','b','c']) %>
SELECT=<%= select("1", ['a','b','c']) %>

VARTEST=<%= @vartest %>

echo <%= ref("AWS::StackName") %> > /tmp/stack_name
# Helper function
function error_exit
{
  /usr/local/bin/cfn-signal -e 1 -r "$1" '<%= ref("WaitHandle") %>'
exit 1
}
# Wait for the EBS volume to show up
while [ ! -e /dev/xvdf ]; do echo Waiting for EBS volume to attach; sleep 1; done
/bin/mkdir /media/redis
/sbin/mkfs -t ext4 /dev/xvdf
echo "/dev/xvdf /media/redis auto defaults 0 0" >> /etc/fstab
/bin/mount /media/redis
/usr/bin/redis-cli shutdown
sleep 10
mv /var/lib/redis/* /media/redis/
rm -r /var/lib/redis
ln -s /media/redis /var/lib/redis
chown -R redis:redis /var/lib/redis
chown -R redis:redis /media/redis
/usr/bin/redis-server
# If all is well so signal success
/usr/local/bin/cfn-signal -e $? -r "Ready to rock" '<%= ref("WaitHandle") %>'
cat /proc/uptime | cut -f1 -d'.' > /tmp/time-to-boot