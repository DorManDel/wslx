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

## Windows / WSL Git portability

WSLX may be developed from a repository stored on a Windows-mounted
filesystem such as `/mnt/c`, `/mnt/d`, or another mounted Windows drive.

### File-mode metadata

Windows NTFS and Linux do not expose Unix executable permission metadata in
exactly the same way.

A clean repository may therefore appear modified even when file contents have
not changed, for example:

```text
mode change 100644 => 100755
```

When the change is metadata-only, configure that clone locally with:

```bash
git config core.fileMode false
```

This setting is intentionally repository-local. It prevents Git from treating
Windows/WSL permission-mode differences as source-code changes.

### Line endings

Windows commonly uses CRLF line endings while Linux and WSL tools expect LF.

WSLX therefore uses the repository-root `.gitattributes` file to normalize
text and force Linux-oriented files such as `.sh` and `.bash` to use LF.

This is especially important for shell scripts because CRLF can introduce a
literal carriage-return character (`\r`) into the shebang or script content
and cause execution failures.

`core.fileMode=false` and `.gitattributes` solve different problems:

```text
core.fileMode=false
    -> local filesystem permission metadata

.gitattributes
    -> repository text and line-ending policy
```

### ShellCheck

ShellCheck is the static-analysis tool used for WSLX shell code.

The runtime and structural tests verify behavior, while ShellCheck catches
shell-language problems that tests may not execute directly, such as unsafe
word splitting, ambiguous `A && B || C` control flow, and accidental command
substitution inside heredocs.

The Makefile follows sourced WSLX libraries during linting so the static
analysis understands the project's modular shell structure.

## Validate

```bash
make test
make lint
make check
```

`make check` is the pre-commit gate.

ShellCheck remains an optional external dependency so the dependency-free test
suite can still run on a fresh environment. For WSLX maintainers, however,
ShellCheck should be installed and `make lint` should pass before committing or
publishing a validated baseline.

## Commit naming

Use a task number plus a concise conventional message, for example:

```text
chore: WSLX-001 project foundation
feat: WSLX-002 add PathX
```
