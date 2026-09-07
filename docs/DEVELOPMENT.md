# Development Workflow

Every meaningful WSLX change follows the same small loop:

```text
1. Create timestamp record
2. Update implementation
3. Update/extend tests
4. Update relevant explanation docs
5. Update docs/MAP.md
6. Update docs/CURRENT_STATE.md
7. Run make check
8. Commit
```

## Start a change

```bash
make change NAME=add-pathx
```

This creates a timestamped Markdown record in `docs/changes/` using the local
time zone.

## Required documentation discipline

When a change affects structure or responsibility, update `docs/MAP.md` in the
same commit. When it affects a command, update its future
`docs/commands/<command>.md` explanation as well.

The production source should contain comments that explain responsibility and
non-obvious decisions. Detailed line-by-line teaching belongs in the docs so
source files stay readable.

## Validate

```bash
make test
make lint
make check
```

`make check` is the pre-commit gate. ShellCheck is optional at Foundation 001:
if it is not installed, lint prints a clear skip message while dependency-free
automated tests still run.

## Commit naming

Use a task number plus a concise conventional message, for example:

```text
chore: WSLX-001 project foundation
feat: WSLX-002 add PathX
```
