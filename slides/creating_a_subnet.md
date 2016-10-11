## Creating a Subnet

**04-subnet.yaml**

```yaml
  mysubnet:
    type: OS::Neutron::Subnet
    properties:
      cidr: 10.0.0.1/24
      name: mysubnet
      network:
        get_resource: mynetwork
```

**Create the stack**

```
heat stack-create --poll -f /tmp/stack.yaml mystack
```

_Partial:_ `partial04.yaml`

<!--
Once the network is created we need a subnet to assign IP addresses from. This
is the first time we will use a Heat function, namely get_resource, to tell the
subnet resource what network to be on.
-->

