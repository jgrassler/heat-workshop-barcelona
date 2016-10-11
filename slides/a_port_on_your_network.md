## A Port on your Network

**05-port.yaml**
~~~ yaml
  myport:
    type: OS::Neutron::Port
    properties:
      network:
        get_resource: mynetwork
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial05.yaml`

<!--
Along with the network and subnet we need a virtual port to connect the
instance to. One could associate a floating IP with an instance directly, but
with a port you get to control the network for machines on multiple networks.
-->

