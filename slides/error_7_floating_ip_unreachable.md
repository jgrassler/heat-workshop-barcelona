## Error 7: Floating IP unreachable

**Error**

_Pings or SSH to floating IP address time out_

**Resolution**

Create a security group that allows inbound traffic (default is to block everything).

_Partial:_ `partial09.yaml`

<!--
The problem is fairly simple: OpenStack's default security group blocks all
inbound traffic and you need to whitelist the traffic you want to get through
to your instances. You do that by creating a security group with rules
permitting your desired traffic.

Again, a Heat template somebody downloads from the Internet may make
assumptions: namely, that it runs in an environment where somebody modified the
default security group's rules to allow inbound traffic (which is not a good
idea, but still a fairly common practice).
-->

