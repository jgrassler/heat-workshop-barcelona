# Introduction

## What is Heat?

* Orchestration Service controlled by instructions in HOT resource description
  language (or CloudFormation CFN templates)

* Introduced in OpenStack Icehouse

* Really usable as of OpenStack Kilo (some teething trouble)

* Terminology: Heat _Templates_ (written in HOT) describe a setup consisting of
  one or more resources and are instantianted as Heat _Stacks_.

<!--
I'll start off with the TL;DR on Heat. It is Openstack's *orchestration*
component. In plain english this means that it manages and coordinates all the
other OpenStack services, much like a conductor for an orchestra. The score
that describes the "music" being played is written in the HOT resource
description language. CFN templates will work as well, so expect customers who
try to get their CloudFormation templates running on Heat.

Heat has been around for a while: it got introduced formally in Icehouse and
when Kilo came around a bunch of fairly annoying bugs got fixed which made it
really usable.

A word on terminology I'll use throughout this training: Heat processes
so-called "Heat Templates" which are files written in the HOT template
language. This is the score used for cloud orchestration, to put it in musical
terms. These templates are *instantiated*, which is to say, the resources
described in them are created. The result is called a Heat *Stack*.
-->

## This Workshop

* Heat Services and Architecture

* Anatomy of a Heat Template

* Hands on: Let's try and break things...

<!--
I'll start of this workshop of giving you a bit of an introduction to Heat and
the basics on Heat templates. I will try to keep this one brief, because its
main focus is using Heat and finding the stumbling blocks customers are going
to encounter.
-->

## Services and Architecture

* heat-api: OpenStack API

* heat-api-cfn: Cloud Formation Compatible API

* heat-engine: sends resource creation requests to other services (Nova,
  Neutron, ...)

<!--
First a quick overview of services that need to be running for Heat to work:

* You'll need heat-api on the user facing side. Both Horizon and the command
  line Heat client talk to this API.
* You'll need heat-api-cfn for CloudFormation clients to be able to talk to Heat
* You'll need heat-engine in the background. Both APIs communicate with
  heat-engine through rabbitmq, and heat-engine performs the actual work of
  handling operations on Heat stacks.
-->

# Anatomy of a Heat Template

## Overview

* Two possible formats for data payload: YAML or JSON (YAML recommended)

* Sections:

  * `heat_template_version`: Governs available features

  * `parameters`: Parameters that can be supplied through command line or web interface

  * `resources`: The resources to be created

  * `outputs`: data to pass back to the user upon stack creation

<!--
Now for the interesting part: What is a Heat template?

It's a YAML or JSON formatted file that describes a Heat stack. Please use the
YAML format and get the customers to do so, too. Using YAML will save you lots
of brackets and braces.

In either format the template is divided into a bunch of sections. I'll only
list the most important ones. Most of these are optional (even `resources`, but
a heat-template without this section is rather pointless), except for the first
one:

* `heat_template_version` contains the date of an OpenStack release. This will
  tell Heat which subset of features to support. In this example we will use
  2015-10-16, the release date of OpenStack Liberty. `heat_template_version` is
  mandatory and must not be omitted.

* `parameters` contains parameters, possibly with defaults. Anybody using a
  template providing parameters can then customize it by supplying their own
  parameters, such as the SSH Keypair granted access to Nova instances.

* `resources` contains descriptions of the OpenStack resource to be created.
  This is the main part of a Heat template and it's where most of the
  interesting stuff happens.

* `outputs` contains various data to be passed back to the user after stack
  creation. This can be used to convey information such as the Floating IP an
  instance got assigned.

-->

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

## Command Line Heat Client (2)

**Detailed Information about stack `mystack`**
~~~
heat stack-show mystack
~~~
Error messages (if any) in field `stack_status_reason` (more readable in
`heat-engine.log`, if you have access)

**List resources of stack `mystack`**
~~~
heat resource-list -n 5 mystack
~~~

**List outputs for stack `mystack`**
~~~
heat output-list mystack
~~~

**Get Output `floating_ip` from stack mystack**
~~~
heat output-show mystack floating_ip
~~~

<!--
* To get detailed information about an existing stack you can use `heat
  stack-show`. That's mainly useful for a stack that ends up in state
  `CREATE_FAILED` for some reason. In that case `stack_status_reason` will
  contain error output.

* Also useful: resource-list. It will show you a stack's component resources and
  their state. If a stack fails to build you can identify the culprit that way.
  The `-n` option tells Heat to resolve the component resource of (up to 5)
  nested Heat stacks, that is stacks that consist of multiple nested Heat
  templates.

* If a stack has outputs defined you can list them with `heat output-list` and
  display an individual output's value using `heat output-show`.

-->

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

## Heat Functions

**get_param**
~~~ yaml
key_name: { get_param: key_name }
~~~

**get_resource**
~~~ yaml
networks:
        - port: { get_resource: myport }
~~~

**`get_attr`**
~~~ yaml
outputs:
  floating_ip_address:
    description: The server's floating IP address.
    value: 
      get_attr: 
        - myfloating_ip          # resource
        - floating_ip_address  # attribute
~~~

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

# Hands-on: Creating a Heat Stack

<!--
So much for the theoretical bits. Now for the pratical part. Each of you should
have access to a OpenStack cloud with Heat available already. If you do not,
please speak up.

On this cloud we will be experimenting with Heat now. We will write a fairly
elaborate Heat template bit by bit and test it with each resource we add. In a
nutshell we'll create a server with a floating IP address, but we will do it in
a way that makes as few assumptions as possible about available resources such
as networks or security groups in your OpenStack tenant. I'll show you each
resource on the projector. Please type them out - that is likely to create all
sorts of transcription errors and will probably give us additional errors to
debug on top of the ones I already prepared.

That's deliberate: I expect there to be errors in the templates and hope some
of you will mind showing their error messages on the big screen so we can debug
them together. If nobody is willing to show their template on screen that's
fine. I can introduce errors into _my_ template and we can debug these, but I'd
rather go for non-artifical ones.

Either way, I will take notes on each problem we encounter (I'm fairly sure
we'll find some stuff I didn't think of in advance) and write a troubleshooting
guide based on these notes.
-->

## Preparations

**Get a local copy of slides**

~~~
git clone https://github.com/jgrassler/talks.git
cd talks/heat-workshop
~~~

**Install Heat command line client** 

~~~
zypper install python-heatclient     # SUSE
yum install python-heatclient        # RedHat
aptitude install python-heatclient   # Debian/Ubuntu
~~~

**Prepare openrc**

Log in to the cloud dashboard using one of the credentials sheets we handed out
and download an openrc to ~/openrc.workshop. Source that openrc:

~~~
source ~/openrc.workshop
~~~

<!--
Some of the slides may not be all that readable, especially from the far wall,
so you can grab a copy of this presentation and all supporting material from my
Github repository. I strongly recommend doing this, because that way you will
also get partial Heat templates for each step, in case you get stuck somewhere.

Also, if you don't have it, yet. Please install a Heat client now and source an
openrc for a cloud with the Heat service running. If you have one of your own
feel free to use that. Otherwise you can log in to ours using the credentials
on the sheets we handed out.

Please append all the template snippets from the following slides to
/tmp/stack.yaml. If you get really stuck on an exercise you can get a
known-good snippet for each exercise from the snippets/without-errors
directory. And if you need to catch up really quickly you can copy the
appropriate partial template from the `partial/` directory (you'll find its
file name at the bottom of each slide).
-->

## A minimal template

**with-errors/01-minimal.yaml**

~~~ yaml
heat_template_version: 2525-01-01
~~~

**Try to create stack**

~~~
. /root/openrc.myuser
heat stack-create --poll -f \
     /tmp/stack.yaml mystack
~~~

_Partial:_ `partial01-broken.yaml`

<!--
Our first exercise will use the smallest valid Heat template: just a
heat_template_version section. It contains an obvious error, but please copy it
exactly the way it is, after all we're interested in the error message it
provokes.
-->

## Error 1: `heat_template_version`

_Partial:_ `partial01-broken.yaml`

**Error Message**

~~~
ERROR: The template version is invalid: "heat_template_version: 2525-01-01". "heat_template_version" should be one of: 2013-05-23, 2014-10-16, 2015-04-30, 2015-10-15
~~~

**Resolution**

Pick one of the template versions supported by your cloud (`2015-10-15` or
lower for the cloud we provided) from the list above.

_Partial:_ `partial01.yaml`

<!--
So here we have our error message: We are using an unrealistically high
heat_template_version. The error message is fairly helpful and gives us a list
of supported versions, so please pick one from that list. In the following
examples we'll use 2015-10-15, so that one is the best one to pick in our case.
-->

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

## Error 2: Tabs versus spaces

_Partial:_ `partial02-broken.yaml`

**Error Message**

~~~ yaml
Error parsing template file:///crypt/home/johannes/src/talks/heat-workshop/partial/partial02-broken.yaml while scanning for the next token
found character that cannot start any token
  in "<unicode string>", line 13, column 1
~~~

**Resolution**

Check the problematic line for a mix of tabs and spaces. Depending on your
tabstop setting it may not be obvious at first. The same error may also occur
due to a key starting with non-alphanumeric characters.

**Retry stack creation**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial02.yaml`

<!-- 
To provoke this error message you need to modify your parameters section.
Substitute one of the leading spaces in line 7 by a tab (bonus points if the
number of spaces in the other lines matches your tabstop setting). The message
not very helpful since it doesn't point out the actual cause of the problem,
but at least it gives you the correct line number.
-->

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

## Creating a Subnet

**04-subnet.yaml**

~~~ yaml
  mysubnet:
    type: OS::Neutron::Subnet
    properties:
      cidr: 10.0.0.1/24
      name: mysubnet
      network:
        get_resource: mynetwork
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial04.yaml`

<!--
Once the network is created we need a subnet to assign IP addresses from. This
is the first time we will use a Heat function, namely get_resource, to tell the
subnet resource what network to be on.
-->

## A Port on your Network

**05-port.yaml**
~~~ yaml
  myport:
    type: OS::Neutron::Port
    properties:
      network:
        get_resource: mynetwork
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial05.yaml`

<!--
Along with the network and subnet we need a virtual port to connect the
instance to. One could associate a floating IP with an instance directly, but
with a port you get to control the network for machines on multiple networks.
-->

## Creating an Instance

**06-server.yaml**
~~~ yaml
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
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial06.yaml`

<!--
Now comes the centerpiece of the heat template: the instance supported by all
virtual infrastructure we created so far (and the infrastructure we are going
to create in the next few steps). This is the first time we use the get_param
function to retrieve template parameters. We can abuse these parameters to
provoke one of the next two errors. But let's have another error first.
-->

## Error 4: SSH key not found

**Error Message**
~~~
ERROR: Property error: : resources.myserver.properties.key_name: : Error
validating value 'mykey': The Key (mykey) could not be found.
~~~

**Resolution**

~~~
nova keypair-add --pub-key ~/.ssh/id_rsa.pub mykey
~~~

_Partial:_ `partial06.yaml`

<!--
Namely, I omitted a little something on the preparation slide to show you a
particular Heat feature: It will validate properties passed to resources (where
that makes sense) and complain if you supply invalid values, such as a
nonexistent Nova key pair name. Let's create that key pair now and retry the
stack-create.
-->

## Error 5: No valid host was found

**Modified command**

~~~
heat stack-create --poll -f /tmp/stack.yaml -P flavor m1.ginormous mystack
~~~

**Error message**

~~~
resources.myserver: Went to status ERROR due to "Message: No valid host was
found. There are not enough hosts available., Code: 500"
~~~

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

## Attempt to associate a floating IP

**09-float.yaml**
~~~ yaml
  myfloatingip:
    type: OS::Neutron::FloatingIP
    properties:
      port_id: { get_resource: myport }
      floating_network:
        get_param: floating_network
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial09-broken.yaml`

<!--
Next let's connect our server by adding a Floating IP Address to it. To this
end, please add the myfloatingip resource to your template.
-->

## Error 6: External network not reachable

**Check stack status**

~~~
heat stack-show mystack
~~~

**Error message**

~~~
NotFound: resources.floatingip: External network
27011e4a-1727-499a-9c1f-b372a62071a9 is not reachable from subnet
dbe382bd-0ccf-4107-9f96-8cecad3797f1  Therefore, cannot associate Port
162b6498-13ce-46b9-a436-76fb50f06c67 with a Floating IP.
~~~

**Resolution**

Comment/Remove the `floatingip` resource for now. We need a router first.

_Partial:_ `partial06.yaml`

<!--
As you probably guessed from the partial file name, I led you astray there: the
goal of our Heat template is to provide _all_ required infrastructure. This
includes a router, which won't exist for our freshly created network. The
reason I caused this error is that you might encounter this kind of problem in
the wild: 

Let's assume somebody publishes a Heat template that doesn't create its own
network/subnet but takes the network as a parameter, making the assumption that
this network _has_ a router. Now you download this template, pass a network
without a router and it doesn't work now. Now you'll know why that happens if
it does.

Anyway, please remove the floatingip resource now. You can also comment it out
if you like, the comment sign in Heat templates is a Hash sign ('#'), the same
you'd use in a shell script.
-->

## Creating a Router

**07-router.yaml**
~~~ yaml
  router:
    type: OS::Neutron::Router
    properties:
      external_gateway_info:
        network:
          get_param: floating_network
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial07.yaml`

<!--
So let's create a virtual router now. This is a resource Neutron provides
and it's neccessary for providing SNAT or providing routing for Floating IPs
associated with Nova instances. Creating the router will only take care of the
external side of things, which is to say, the router will have a leg on the
external network (the external_gateway_info property tells it to have an
interface on our floating IP network) but not on our project network.
-->

## Adding A RouterInterface

**08-interface.yaml**
~~~ yaml
  router_interface:
    type: OS::Neutron::RouterInterface
    properties:
      router: { get_resource: router }
      subnet: { get_resource: mysubnet }
~~~

**Create the stack**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
~~~

_Partial:_ `partial08.yaml`

<!--
The internal side we are going to take care of with a RouterInterface. That
creates a Neutron port on a subnet, the subnet created by our template in this
case.
-->

## Associating a Floating IP

**09-float.yaml**
~~~ yaml
  myfloatingip:
    type: OS::Neutron::FloatingIP
    properties:
      port_id: { get_resource: myport }
      floating_network:
        get_param: floating_network
~~~

**Create the stack and display floating IP**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
heat resource-show mystack myfloatingip
~~~

_Partial:_ `partial09.yaml`

<!--
With the router and its router interface on our subnet in place, we can again
add the Floating IP from three slides back. Once you have created the stack you
can figure out which floating IP got assigned by doing a `resource-show` on the
stack's myfloatingip resource this is somewhat clumsy since resource-show will
dump a lot of unrelated information, but it has the advantage of always
working. The more convenient method we'll cover later will only work if the
template author has provided for it.
-->

## Error 7: Floating IP unreachable

**Error**

_Pings or SSH to floating IP address time out_

**Resolution**

Create a security group that allows inbound traffic (default is to block everything).

_Partial:_ `partial09.yaml`

<!--
The problem is fairly simple: OpenStack's default security group blocks all
inbound traffic and you need to whitelist the traffic you want to get through
to your instances. You do that by creating a security group with rules
permitting your desired traffic.

Again, a Heat template somebody downloads from the Internet may make
assumptions: namely, that it runs in an environment where somebody modified the
default security group's rules to allow inbound traffic (which is not a good
idea, but still a fairly common practice).
-->

## Security Groups to the Rescue

**10-group.yaml**
~~~ yaml
  allow_inbound:
    type: OS::Neutron::SecurityGroup
    properties:
      description: "Allow inbound SSH and ICMP traffic"
      name: allow SSH and ICMP from anywhere
      rules:
        - direction: ingress
          remote_ip_prefix: 0.0.0.0/0
          protocol: tcp
          port_range_min: 22
          port_range_max: 22
        - remote_ip_prefix: 0.0.0.0/0
          protocol: icmp
~~~

**Create the stack and display floating IP**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
heat resource-show mystack myfloatingip
~~~

_Partial:_ `partial10.yaml`

<!--
So let's add a security group that allows SSH and ICMP to our template now.
Once it's there create the stack and ping its floating IP address again.
-->

## Error 8: Security Group not associated

**Error** 

Floating IP not reachable despite security group.

**Resolution**

Associate the security group with the port it is supposed to apply to.

_Partial:_ `partial10.yaml`

<!--
Oops. It's still not working. Once again I snuck in an error: for a security
group to apply to a given instance or port it must be associated with that
port. Otherwise it won't have any effect at all (unless it's the default
security group, of course).

It's an easy mistake to make, especially because there's no warnings or error
messages hinting at the problem and in the natural order of things you first
create the port, then a whole bunch of other things. Only a lot later you
create the security group, but forget to add it to one or more ports. And it's
hard to spot, too.

And there's no indication anything is wrong: you get a CREATE_COMPLETE for your
stack and all looks fine, except for that pesky little detail of the instance
being unreachable.
-->

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

## Outputs: What's my Floating IP?

**12-outputs.yaml**
~~~ yaml
outputs:
  floating_ip:
    value:
      get_attr:
        - myfloatingip
        - floating_ip_address
~~~

**Create the stack and display floating IP**

~~~
heat stack-create --poll -f /tmp/stack.yaml mystack
heat output-show mystack floating_ip
~~~

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

## Error 9: Can't delete stack

**Error message upon `stack-delete`**

~~~
Unable to complete operation on subnet
d5bda832-2816-4453-932e-c739cc0f1152. One or more ports
have an IP allocation from this subnet.
~~~

**Resolution**

~~~
neutron port-list | grep d5bda832-2816-4453-932e-c739cc0f1152 | awk '{ print $2}'
~~~

This will give you a list of Neutron port IDs. One of them belongs to
`myserver` from the Heat stack, the rest are freeloaders. You need to get rid
of the freeloaders somehow (better talk to their owners first).

<!--
Last but not least I've got a little bonus error for you. This kind of error
will happen a lot once people use Heat in earnest, especially in multi-user
projects. We will now create our stack one last time. Once it is up and running
we will use the OpenStack Dashboard to spawn an instance. When we do this we
select the `mynet` network created by our Heat stacks in the Networking tab.
Once the instance is up and running we try to delete our Heat stack.

And presto, it doesn't work. Now why is that? It boils down to Neutron refusing
to delete a subnet with ports still using IPs from that Subnet, which is quite
sensible really. So now you need to get rid of these. I strongly recommend
talking to their owners first. If you can't do that for some reason, it's best
to just delete the ports (maybe disassociating Floating IPs if neccessary) and
leave the instances alone. At least the users who created them won't lose their
data that way.

But the best thing to do is to prevent this situation from occuring in the
first place. I have a couple of suggestions for that:

* Separate Heat stacks and manually created instances into separate projects

* Education and prevention: prefix the names of Heat created resources with
  `heat_` and tell Dashboard users to leave these alone. I have seen this work
  before, but it never scaled beyond 10-15 users.

Of course these are far from perfect, but if you do have that problem a lot
they might help.
-->
