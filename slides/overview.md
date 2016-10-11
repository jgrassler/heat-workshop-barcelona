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

