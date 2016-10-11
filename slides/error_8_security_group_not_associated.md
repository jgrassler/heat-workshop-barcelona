## Error 8: Security Group not associated

**Error** 

Floating IP not reachable despite security group.

**Resolution**

Associate the security group with the port it is supposed to apply to.

_Partial:_ `partial10.yaml`

<!--
Oops. It's still not working. Once again I snuck in an error: for a security
group to apply to a given instance or port it must be associated with that
port. Otherwise it won't have any effect at all (unless it's the default
security group, of course).

It's an easy mistake to make, especially because there's no warnings or error
messages hinting at the problem and in the natural order of things you first
create the port, then a whole bunch of other things. Only a lot later you
create the security group, but forget to add it to one or more ports. And it's
hard to spot, too.

And there's no indication anything is wrong: you get a CREATE_COMPLETE for your
stack and all looks fine, except for that pesky little detail of the instance
being unreachable.
-->

