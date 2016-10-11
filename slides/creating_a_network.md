## Creating a Network

**Begin resources section after parameters section**

~~~ yaml
resources:
~~~

**03-network.yaml**
~~~ yaml
  mynetwork:
    type: OS::Neutron::Net
    properties:
      name: mynet
~~~

**Create the stack**
~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial03.yaml`

<!--
Now we'll create a resources section and add our first resource: a Neutron
network. The server we will create later will be on this network. The
'resources:' keyword beginning the resources section is at the same indentation
level as the 'parameters:' keyword for the parameters section we created in the
previous step (no indentation). Resource definitions, such as the one for
mynetwork come after the 'resources:' keyword and should be indented with two
spaces.
-->

