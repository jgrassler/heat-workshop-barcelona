## Creating an Instance

**06-server.yaml**

```yaml
  myserver:
    type: OS::Nova::Server
    properties:
      name: myserver
      config_drive: true
      flavor: { get_param: flavor }
      image: { get_param: image }
      key_name: { get_param: key_name }
      networks:
        - port: { get_resource: myport }
      user_data_format: RAW
      user_data: |
        #!/bin/sh
        echo 'Hello, World' >> /etc/motd
```

**Create the stack**

```
heat stack-create --poll -f /tmp/stack.yaml mystack
```

_Partial:_ `partial06.yaml`

<!--
Now comes the centerpiece of the heat template: the instance supported by all
virtual infrastructure we created so far (and the infrastructure we are going
to create in the next few steps). This is the first time we use the get_param
function to retrieve template parameters. We can abuse these parameters to
provoke one of the next two errors. But let's have another error first.
-->

