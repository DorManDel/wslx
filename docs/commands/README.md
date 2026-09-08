# Command Explanation Documents

Every implemented WSLX command gets one focused document here.

The public name, alias and grammar are defined first in `docs/COMMANDS.md`.
Implementation starts only after the command contract is clear.

## Standard command contract

Use this shape before implementation:

```text
Problem:
What repeated Windows/WSL friction does this solve?

Canonical:
wslx <command> ...

Shortcut:
Only when the command is frequent enough to justify one.

Input:
Accepted path/data/program forms.

Behavior:
step 1
→ step 2
→ result

Output:
What goes to stdout/stderr and whether it is pipe-safe.

Side effects:
Filesystem, shell-state, process, clipboard or GUI effects.

Backend:
Native/external commands used.

Errors:
Important failure cases and exit codes.

Safety:
Rules that prevent surprising or destructive behavior.

Tests:
Contract cases that must pass before merge.

Important:
Architecture constraints that affect implementation.
```

## Detailed implementation document

Once implemented, extend the command document with:

1. Purpose and user-facing semantics.
2. Syntax/options/operands.
3. Examples.
4. Execution flow.
5. External dependencies/backends.
6. Internal function responsibilities.
7. Error handling and exit codes.
8. Edge cases.
9. Automated tests.
10. Planned integrations or improvements.

Current command document:

- `path.md` — WSLX-002 path interoperability.
