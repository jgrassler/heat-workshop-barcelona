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

