## Heat Resources: An example

~~~ yaml
resources:
  myserver:
    type: OS::Nova::Server
    properties:
      name: myserver
      key_name: { get_param: key_name }
      image: { get_param: image }
      flavor: { get_param: flavor }
      networks:
        - port: 
            get_resource: myport
~~~

<!--
Let's work our way up to the hands-on part and look at what we'll be working
with: Heat resources. Here you see an example of a Heat resource's definition,
namely a Nova instance. Note the indentation that marks it as belonging to the
`resources` section.

It starts off with a resource name, "myserver" in this case. You can use this
name to reference the resource in other parts of the Heat template.

One indentation level further down you'll find its resource type,
"OS::Nova::Server" in this case. This will tell Heat which resource plugin and
in turn which OpenStack service to use to create this resource.

At the same level you will find the optional `depends_on` keyword you can use
to wait for dependencies upon resource creation. It takes one or more resource
names. You normally don't need this, though: if you reference other resources
in a resource definition they will automatically be added as dependencies.

The real meat of a resource is its `properties` section. These properties are
passed to the resource plugin and from there to the creating OpenStack service.
In the case of an instance, you'd commonly pass a Nova keypair name for access
to the instance, the image and the flavor to use. Usually you'll also have at
least one weutron port or network to connect the instance too. In the case at
hand we also have a user data script for setting up the instance.

By the way: you will find most of this information on the cheat sheets I
prepared, so don't worry about catching up if you zoned out looking at this
wall of YAML for a second.
-->

