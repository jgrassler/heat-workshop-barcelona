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

