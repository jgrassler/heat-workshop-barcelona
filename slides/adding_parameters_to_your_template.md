## Adding parameters to your template

**02-parameters.yaml**
~~~ yaml
parameters:
  floating_network:
    type: string
    default: floating
  image:
    type: string
    default: cirros-0.3.4-x86_64
  flavor:
    type: string
    default: m1.tiny
  key_name:
    type: string
    default: root
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial02.yaml`

