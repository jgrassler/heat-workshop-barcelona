## Creating a Router

**07-router.yaml**
~~~ yaml
  router:
    type: OS::Neutron::Router
    properties:
      external_gateway_info:
        network:
          get_param: floating_network
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial07.yaml`

<!--
So let's create a virtual router now. This is a resource Neutron provides
and it's neccessary for providing SNAT or providing routing for Floating IPs
associated with Nova instances. Creating the router will only take care of the
external side of things, which is to say, the router will have a leg on the
external network (the external_gateway_info property tells it to have an
interface on our floating IP network) but not on our project network.
-->

