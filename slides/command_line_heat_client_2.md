## Command Line Heat Client (2)

**Detailed Information about stack `mystack`**

```
heat stack-show mystack
```

Error messages (if any) in field `stack_status_reason` (more readable in
`heat-engine.log`, if you have access)

**List resources of stack `mystack`**

```
heat resource-list -n 5 mystack
```

**List outputs for stack `mystack`**

```
heat output-list mystack
```

**Get Output `floating_ip` from stack mystack**

```
heat output-show mystack floating_ip
```

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

