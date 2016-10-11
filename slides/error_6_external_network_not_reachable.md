## Error 6: External network not reachable

**Check stack status**

```
heat stack-show mystack
```

**Error message**

```
NotFound: resources.floatingip: External network
27011e4a-1727-499a-9c1f-b372a62071a9 is not reachable from subnet
dbe382bd-0ccf-4107-9f96-8cecad3797f1  Therefore, cannot associate Port
162b6498-13ce-46b9-a436-76fb50f06c67 with a Floating IP.
```

**Resolution**

Comment/Remove the `floatingip` resource for now. We need a router first.

_Partial:_ `partial06.yaml`

<!--
As you probably guessed from the partial file name, I led you astray there: the
goal of our Heat template is to provide _all_ required infrastructure. This
includes a router, which won't exist for our freshly created network. The
reason I caused this error is that you might encounter this kind of problem in
the wild: 

Let's assume somebody publishes a Heat template that doesn't create its own
network/subnet but takes the network as a parameter, making the assumption that
this network _has_ a router. Now you download this template, pass a network
without a router and it doesn't work now. Now you'll know why that happens if
it does.

Anyway, please remove the floatingip resource now. You can also comment it out
if you like, the comment sign in Heat templates is a Hash sign ('#'), the same
you'd use in a shell script.
-->

