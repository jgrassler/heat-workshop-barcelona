# Building a Heat Template from the Ground up

This workshop will teach you to build a OpenStack Heat template from the ground
up. The traditional approach to learning Heat usually involves setting up
WordPress or another application through a Heat template. This lab is
different. Namely, there will be no application at the end of it, just a VM
with "Hello, world" in its message of the day. This gives us the luxury of
focussing on what comes before the user-data script that deploys WordPress. The
aim of this lab is a more basic understanding of two things: First, the
building blocks and infrastructure an OpenStack based setup of one or more
servers consists of: virtual machines, virtual networks and floating IP
addresses, to name but a few. Second, it will teach participants how to
describe all of these building blocks reproducibly in terms of a Heat template.
This Heat template will be assembled step by step, with debugging practice for
various common errors along the way.

# FILES

* `presentation.odp`: the workshop's slides in LibreOffice format
* `presentation.pdf`: the workshop's slides in PDF format
* `partial/`: contains partial heat templates for each step
* `snippets/`: contains the Heat template snippets shown on the slides
* `transcript.txt`: contains a transcript of the workshop's audio track

# MODIFYING

This presentation was generated using
[odpdown](https://github.com/thorstenb/odpdown). Please do not edit
presentation.odp directly, but install `odpdown` and run

```
make
```

to generate it from slides.md.
