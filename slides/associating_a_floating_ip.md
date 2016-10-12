## Associating a Floating IP

**09-float.yaml**

```yaml
  myfloatingip:
    type: OS::Neutron::FloatingIP
    properties:
      port_id: { get_resource: myport }
      floating_network:
        get_param: floating_network
```

**Create the stack and display floating IP**

```
heat stack-create --poll -f /tmp/stack.yaml mystack
heat resource-show mystack myfloatingip
```

_Partial:_ `partial09.yaml`

<!--
With the router and its router interface on our subnet in place, we can again
add the Floating IP from three slides back. Once you have created the stack you
can figure out which floating IP got assigned by doing a `resource-show` on the
stack's myfloatingip resource this is somewhat clumsy since resource-show will
dump a lot of unrelated information, but it has the advantage of always
working. The more convenient method we'll cover later will only work if the
template author has provided for it.
-->

