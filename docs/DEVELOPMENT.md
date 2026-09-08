# Development Workflow

Every meaningful WSLX change follows the same small loop:

```text
1. Define/refine the command contract
2. Create/update the timestamp record
3. Update implementation
4. Update/extend tests
5. Update relevant explanation docs
6. Update docs/MAP.md when structure/responsibility changes
7. Update docs/CURRENT_STATE.md
8. Run make check
9. Commit
```

For new commands, use the contract template in `docs/commands/README.md` before
implementation. Naming must agree with `docs/COMMANDS.md`.

## Start a change

```bash
make change NAME=<short-change-name>
```

This creates a timestamped Markdown record in `docs/changes/` using the local
time zone.

## Documentation discipline

When a change affects structure or responsibility, update `docs/MAP.md` in the
same commit. Command behavior belongs in `docs/commands/<command>.md`.

Source comments should explain responsibility and non-obvious decisions. Deep
teaching belongs in docs so production shell code stays readable.

## Windows / WSL Git portability

For repositories stored on `/mnt/c`, `/mnt/d`, or another Windows-mounted
filesystem, use repository-local:

```bash
git config core.fileMode false
```

WSLX also uses `.gitattributes` to normalize text and keep Linux-oriented files
on LF line endings.

## ShellCheck

ShellCheck is the static-analysis tool used for WSLX shell code. Runtime tests
verify behavior; ShellCheck catches shell-language problems that tests may not
execute directly.

## Validate

```bash
make test
make lint
make check
```

`make check` is the pre-commit gate. In an interactive terminal it prints
colored PASS/FAIL output plus a final summary and rerun command for failed test
suites.

For plain logs or CI-style output:

```bash
NO_COLOR=1 make check
```

ShellCheck remains optional for users, but maintainers should install it and
require a clean lint before publishing a validated baseline.

## Commit naming

Use the task number plus a concise conventional message, for example:

```text
chore: WSLX-001 project foundation
feat: WSLX-002 add path interop
```
