## Attempt to associate a floating IP

**09-float.yaml**
~~~ yaml
  myfloatingip:
    type: OS::Neutron::FloatingIP
    properties:
      port_id: { get_resource: myport }
      floating_network:
        get_param: floating_network
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial09-broken.yaml`

<!--
Next let's connect our server by adding a Floating IP Address to it. To this
end, please add the myfloatingip resource to your template.
-->

