## Command Line Heat Client (1)

_Prerequisite: Environment with valid OpenStack credentials_

**Create stack `mystack` from `/tmp/stack.yaml`**

~~~
heat stack-create -f /tmp/stack.yaml mystack
~~~

**With parameter**

~~~
heat stack-create -f /tmp/stack.yaml -P flavor=m1.tiny mystack
~~~

**Delete stack `mystack`** 

~~~
heat stack-delete mystack
~~~

<!--
Now that we know what a Heat template is we'll need to send it to the Heat API
somehow. You can do this through the OpenStack Dashboard, but it's a bit
unwieldy and not really helpful for debugging. So we'll use the Heat command
line client for that. One thing we need for that is a OpenRC file with valid
authentication credentials for your cloud. At this point you probably have one
already, but we'll take care of this later.

Let's go through the most important client operations quickly:

* `heat stack-create` creates a Heat stack from a template. You can optionally
  specify parameters if the defaults in the Heat template don't suit you or a
  parameter is mandatory by virtue of not having a Default.

* Deleting a stack is straightforward: `heat stack-delete`.
-->

