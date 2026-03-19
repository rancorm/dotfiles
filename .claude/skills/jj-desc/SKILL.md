Generate a jj commit description in conventional commit style.

Use the revset `$ARGUMENTS` if provided, otherwise default to `@`.

1. Run `jj diff -r <revset>` to see the changes.
2. Write a conventional commit message: a concise subject line and a summary of changes in the body.
3. Apply it with `jj describe -r <revset> -m <message>`.
