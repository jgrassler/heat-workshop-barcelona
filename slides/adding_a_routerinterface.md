## Adding A RouterInterface

**08-interface.yaml**
```yaml
  router_interface:
    type: OS::Neutron::RouterInterface
    properties:
      router: { get_resource: router }
      subnet: { get_resource: mysubnet }
```

**Create the stack**

```
heat stack-create --poll -f /tmp/stack.yaml mystack
```

_Partial:_ `partial08.yaml`

<!--
The internal side we are going to take care of with a RouterInterface. That
creates a Neutron port on a subnet, the subnet created by our template in this
case.
-->

