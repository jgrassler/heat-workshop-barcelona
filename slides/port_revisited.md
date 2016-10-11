## Port revisited

**11-port.yaml**
~~~ yaml
  myport:
    type: OS::Neutron::Port
    properties:
      network:
        get_resource: mynetwork
      security_groups:                # NEW
        - get_resource: allow_inbound # NEW
~~~

**Create the stack and display floating IP**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
heat resource-show mystack floatingip
~~~

_Partial:_ `partial11.yaml`

<!--
So let's fix this omission now by adding a security_groups property to our
port resource. Just add the lines marked with a 'NEW' comment to our template's
port resource. Once you have them, create the stack once more and ping the
instance's floating IP. This time it should _really_ work - at least I didn't
add any more deliberate errors. You can also log in to the machine using SSH
and make sure your user data script did in fact change /etc/motd.
-->

<!-- =============== END OF RESOURCES SECTION ================ -->

