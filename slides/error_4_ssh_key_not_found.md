## Error 4: SSH key not found

**Error Message**

```
ERROR: Property error: : resources.myserver.properties.key_name: : Error
validating value 'mykey': The Key (mykey) could not be found.
```

**Resolution**

```
nova keypair-add --pub-key ~/.ssh/id_rsa.pub mykey
```

_Partial:_ `partial06.yaml`

<!--
Namely, I omitted a little something on the preparation slide to show you a
particular Heat feature: It will validate properties passed to resources (where
that makes sense) and complain if you supply invalid values, such as a
nonexistent Nova key pair name. Let's create that key pair now and retry the
stack-create.
-->

