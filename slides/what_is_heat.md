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

