## Error 1: `heat_template_version`

_Partial:_ `partial01-broken.yaml`

**Error Message**

```
ERROR: The template version is invalid: "heat_template_version: 2525-01-01". "heat_template_version" should be one of: 2013-05-23, 2014-10-16, 2015-04-30, 2015-10-15
```

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

