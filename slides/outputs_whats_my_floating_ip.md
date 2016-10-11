## Outputs: What's my Floating IP?

**12-outputs.yaml**
```yaml
outputs:
  floating_ip:
    value:
      get_attr:
        - myfloatingip
        - floating_ip_address
```

**Create the stack and display floating IP**

```
heat stack-create --poll -f /tmp/stack.yaml mystack
heat output-show mystack floating_ip
```

_Partial:_ `partial12.yaml`

<!--
Now we are almost done. I did promise you a more convenient method to figure
out the Floating IP. Also, we haven't used the get_attr function so far. Let's
do both in one fell swoop. Please add this last snippet at the end of the
template and create the stack one last time. The snippet in question is an
outputs section and it contains one output named floating_ip which will
retrieve the floating IP address using the get_attr function.

Now you will have an output named floating_ip and it will contain just the
floating IP adress. This is a lot more convenient than plucking it from
resource-show's output.
-->

