## Error 9: Can't delete stack

**Error message upon `stack-delete`**

```
Unable to complete operation on subnet
d5bda832-2816-4453-932e-c739cc0f1152. One or more ports
have an IP allocation from this subnet.
```

**Resolution**

```
neutron port-list | grep d5bda832-2816-4453-932e-c739cc0f1152 | awk '{ print $2}'
```

This will give you a list of Neutron port IDs. One of them belongs to
`myserver` from the Heat stack, the rest are freeloaders. You need to get rid
of the freeloaders somehow (better talk to their owners first).

<!--
Last but not least I've got a little bonus error for you. This kind of error
will happen a lot once people use Heat in earnest, especially in multi-user
projects. We will now create our stack one last time. Once it is up and running
we will use the OpenStack Dashboard to spawn an instance. When we do this we
select the `mynet` network created by our Heat stacks in the Networking tab.
Once the instance is up and running we try to delete our Heat stack.

And presto, it doesn't work. Now why is that? It boils down to Neutron refusing
to delete a subnet with ports still using IPs from that Subnet, which is quite
sensible really. So now you need to get rid of these. I strongly recommend
talking to their owners first. If you can't do that for some reason, it's best
to just delete the ports (maybe disassociating Floating IPs if neccessary) and
leave the instances alone. At least the users who created them won't lose their
data that way.

But the best thing to do is to prevent this situation from occuring in the
first place. I have a couple of suggestions for that:

* Separate Heat stacks and manually created instances into separate projects

* Education and prevention: prefix the names of Heat created resources with
  `heat_` and tell Dashboard users to leave these alone. I have seen this work
  before, but it never scaled beyond 10-15 users.

Of course these are far from perfect, but if you do have that problem a lot
they might help.

-->

