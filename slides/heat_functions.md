## Heat Functions

**get_param**

```yaml
key_name: { get_param: key_name }
```

**get_resource**

```yaml
networks:
        - port: { get_resource: myport }
```

**`get_attr`**

```yaml
outputs:
  floating_ip_address:
    description: The server's floating IP address.
    value: 
      get_attr: 
        - myfloating_ip        # resource
        - floating_ip_address  # attribute
```

<!--
To conclude the theory section I'd like to examine a few template snippets a
little closer. Two are from the previous example, the third is an example entry
in the outputs section. All of them have *Heat Functions* in common.

These Heat Functions can be used anywhere in the `resources` and `outputs`
sections and return a value that is inserted whereever they are being used.

The first is `get_param`. You use this function to get the value of a
user-specified parameter, such as an SSH key name. This way multiple users with
multiple SSH keys can share the same basic template - they just specify their
own key's name upon stack creation.

The second is `get_resource`. This function is the bread and butter of tying
multiple resources together. It takes a resource name from the template such as
myport and returns that resource's UUID for use in another resource's properties
section.

Finally we have `get_attr`. This function retrieves a resource's *attributes*.
These are not to be confused with its properties. Some properties, such as a
host name may be copied straight over to attributes. But others only become
known after resource creation, such as a floating IP drawn from a pool of
external addresses. This function is mainly useful in an outputs section to
pass this kind of not-known-in-advance information to the user.

Note the missing curly braces by the way. YAML supports both the JSON syntax I
used for the previous two functions and its own indentation based one. They are
equivalent and In the field you may encounter both so I will use both
throughout this presentation. The convention I have observed so far appears to
be using the JSON syntax for functions and their parameters. I will
occasionally break this convention for the sake of readability.
-->

