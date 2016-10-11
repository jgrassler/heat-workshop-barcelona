## Preparations

**Get a local copy of slides**

```
git clone https://github.com/jgrassler/talks.git
cd talks/heat-workshop
```

**Install Heat command line client** 

```
zypper install python-heatclient     # SUSE
yum install python-heatclient        # RedHat
aptitude install python-heatclient   # Debian/Ubuntu
```

**Prepare openrc**

Log in to the cloud dashboard using one of the credentials sheets we handed out
and download an openrc to ~/openrc.workshop. Source that openrc:

```
source ~/openrc.workshop
```

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

