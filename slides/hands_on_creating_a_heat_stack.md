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

