## Error 2: Tabs versus spaces

_Partial:_ `partial02-broken.yaml`

**Error Message**

```
Error parsing template file:///crypt/home/johannes/src/talks/heat-workshop/partial/partial02-broken.yaml while scanning for the next token
found character that cannot start any token
  in "<unicode string>", line 13, column 1
```

**Resolution**

Check the problematic line for a mix of tabs and spaces. Depending on your
tabstop setting it may not be obvious at first. The same error may also occur
due to a key starting with non-alphanumeric characters.

**Retry stack creation**

```
heat stack-create --poll -f /tmp/stack.yaml mystack
```

_Partial:_ `partial02.yaml`

<!-- 
To provoke this error message you need to modify your parameters section.
Substitute one of the leading spaces in line 7 by a tab (bonus points if the
number of spaces in the other lines matches your tabstop setting). The message
not very helpful since it doesn't point out the actual cause of the problem,
but at least it gives you the correct line number.
-->

