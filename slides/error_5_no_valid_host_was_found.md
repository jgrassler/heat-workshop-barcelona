## Error 5: No valid host was found

**Modified command**

```
heat stack-create --poll -f /tmp/stack.yaml -P flavor m1.ginormous mystack
```

**Error message**

```
resources.myserver: Went to status ERROR due to "Message: No valid host was
found. There are not enough hosts available., Code: 500"
```

**Resolution**

Have enough resources available, either by picking a smaller flavor or by
having more/bigger compute nodes.

_Partial:_ `partial06.yaml`

<!--
With the key pair problem out of the way we can now abuse the flavor parameter
to cause the next error. Just do the stack-create again but this time please
supply the -P option you see above. We created a special flavour that will not
fit on any of our cloud's compute nodes for the occasion. Unfortunately you
will probably miss out on this if you are using a cloud of your own. This will
cause the flavor value passed on the command line to override the default of
m1.tiny. The value passed on the command line is a bit too large, though so the
nova scheduler will not be able to fit our server anywhere and will report a
failure.

Unfortunately this is a generic Nova error that can occur for a bunch of
other reasons as well: no compute nodes available at all, Neutron agents on
compute nodes being unavailable or throwing errors. But generally it means Nova
or Neutron being unable to instantiate/connect the instance in question. If it
happens it's likely not to be related to the Heat template, with the one
exception of demanding too many resources by requesting a large flavor.
-->

