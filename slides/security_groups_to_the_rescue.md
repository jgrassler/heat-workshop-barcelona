## Security Groups to the Rescue

**10-group.yaml**
```yaml
  allow_inbound:
    type: OS::Neutron::SecurityGroup
    properties:
      description: "Allow inbound SSH and ICMP traffic"
      name: allow SSH and ICMP from anywhere
      rules:
        - direction: ingress
          remote_ip_prefix: 0.0.0.0/0
          protocol: tcp
          port_range_min: 22
          port_range_max: 22
        - remote_ip_prefix: 0.0.0.0/0
          protocol: icmp
```

**Create the stack and display floating IP**

```
heat stack-create --poll -f /tmp/stack.yaml mystack
heat resource-show mystack myfloatingip
```

_Partial:_ `partial10.yaml`

<!--
So let's add a security group that allows SSH and ICMP to our template now.
Once it's there create the stack and ping its floating IP address again.
-->

