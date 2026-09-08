# `wslx cd` / `wcd`

## Purpose

`cd` lets a directory path copied from Windows be used directly to change the
current WSL Bash directory.

```bash
wslx cd 'D:\Programming\Scripts'
```

has the same final effect as:

```bash
cd /mnt/d/Programming/Scripts
```

The fast form is:

```bash
wcd 'D:\Programming\Scripts'
```

## Contract

```text
Canonical:
wslx cd <path>

Shortcut:
wcd <path>

Input:
Windows drive path
WSL/Linux absolute path
relative path
path containing spaces

Behavior:
normalize with existing Path Interop
→ verify that the result exists and is a directory
→ run Bash builtin cd in the current shell

Output:
nothing on success
errors on stderr

Side effect:
changes the current Bash working directory

Backend:
WSLX Path Interop
Bash builtin cd
Linux chdir(2) underneath Bash

Exit codes:
0 success
1 operational failure
2 usage error
```

## Why `cd` is special

A normal WSLX executable runs as a **child process** of Bash.

If that child calls `cd`, only the child moves. When it exits, the parent Bash
shell is still in its old directory.

So WSLX splits the operation:

```text
current Bash shell
      |
      |  wslx cd 'D:\Projects'
      v
WSLX Bash function
      |
      +--> child: command wslx path --wsl 'D:\Projects'
      |             |
      |             `--> prints /mnt/d/Projects
      |                  then exits
      |
      `--> parent Bash receives that path
                    |
                    v
          builtin cd -- /mnt/d/Projects
                    |
                    v
                chdir(...)
                    |
                    v
        same Bash shell, new directory
```

The important rule is:

> The child only calculates the destination. It never changes the parent.

After the child exits, the **parent Bash process** runs its own `cd`. There is
no later return to the child; that child process is already finished.

## Examples

```bash
wslx cd 'D:\Programming\Scripts'
wcd /mnt/d/Programming/Scripts
wcd ../another-project
wcd './folder with spaces'
```

Use `--` if a directory name begins with a dash:

```bash
wcd -- ./-example
```

## Implementation

The current-shell behavior lives in:

```text
shell/bash/wslx.bash
```

It defines:

- `_wslx_cd` — normalize, validate, then change directory.
- `wcd` — the short form.
- `wslx` — a Bash wrapper that intercepts only `wslx cd`; ordinary commands
  are delegated to the real executable with `command wslx`.

Path conversion is not duplicated. The shell integration calls:

```bash
command wslx path --wsl "$input"
```

then:

```bash
builtin cd -- "$target"
```

## Direct executable behavior

This cannot work persistently:

```bash
command wslx cd ...
```

because that executable is a child process. The CLI therefore refuses and
explains that Bash integration is required instead of pretending the directory
change succeeded.

## Tests

`tests/test-cd.sh` verifies canonical and shortcut forms, WSL/Windows/relative
paths, spaces, delegation, error codes, and the direct-child guard.

`tests/test-install.sh` also verifies that the installed shell integration can
change the current shell directory.
