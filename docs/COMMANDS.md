# WSLX Command Language

This is the source of truth for WSLX command names, aliases, options and CLI
grammar.

## Grammar

```text
wslx <command> [options] [operands]
```

Path handling has one deliberate convenience form:

```text
wslx <path>
```

When the first argument clearly looks like a path, WSLX treats it as the `path`
command. Other commands remain explicit.

## Naming rules

1. Canonical commands live under the `wslx` namespace.
2. Names are short, lowercase, familiar actions: `path`, `cd`, `open`, `clip`,
   `run`, `doctor`.
3. Long options favor meaning over cleverness: `--win`, `--wsl`, `--link`.
4. One-letter flags are added only when they are obvious and genuinely useful.
5. `--help` and `--version` keep their standard meaning.
6. `w<command>` shortcuts are reserved for frequent shell actions.
7. Rare commands stay canonical only.
8. Normal stdout must stay useful in scripts and pipes.
9. Interactive decoration must disappear when output is captured.

## Current commands

| Canonical form | Shortcut | Meaning |
|---|---|---|
| `wslx path <path>` | `wslx <path>` | Return a path usable in WSL. |
| `wslx path --wsl <path>` | `wslx --wsl <path>` | Explicitly request WSL form. |
| `wslx path --win <path>` | `wslx --win <path>` | Explicitly request Windows form. |
| `wslx path --link <path>` | `wslx --link <path>` | Display Windows form as an interactive hyperlink when possible. |
| `wslx cd <path>` | `wcd <path>` | Normalize a directory path and change the current Bash directory. |
| `wslx doctor` | — | Diagnose WSLX and its environment. |
| `wslx version` | `wslx --version` | Print the version. |
| `wslx help` | `wslx --help` | Show top-level help. |
| `wslx uninstall` | — | Remove the current-user installation. |

## Path semantics

The default path operation answers:

> What path should I use here, in WSL?

```text
Windows path -> convert to WSL
WSL path     -> leave unchanged
```

Windows form is explicit with `--win`. Clickable presentation is explicit with
`--link`. `--link` falls back to plain text when output is not interactive.

## Shortcut policy

A shortcut is added only when it meaningfully reduces a frequent command:

```text
wslx cd    -> wcd
wslx open  -> wopen
wslx clip  -> wclip
wslx paste -> wpaste
wslx code  -> wcode
wslx run   -> wrun
```

Do not create shortcuts such as `wdoctor`, `wupdate` or `wconfig`.

## Command design gate

Before a planned command becomes implementation work, define:

```text
Problem
Canonical command
Shortcut (if justified)
Input
Behavior
Output
Side effects
Backend
Errors / exit codes
Safety rules
Tests
Important architecture constraints
```

The reusable template lives in `docs/commands/README.md`.

## Planned command contracts

| Command | Alias | Core contract before implementation |
|---|---|---|
| `wslx open <path>` | `wopen <path>` | Normalize input, resolve Windows representation, open the actual file/folder through Windows without changing stdout semantics. |
| `wslx clip [text]` | `wclip` | Copy arguments or stdin exactly to the Windows clipboard; status messages must not pollute piped data. |
| `wslx paste` | `wpaste` | Read clipboard text into WSL stdout so it can be piped or redirected. |
| `wslx code <path>` | `wcode <path>` | Normalize path and open it through the VS Code WSL bridge in the correct context. |
| `wslx run <program> [args...]` | `wrun` | Run a Windows program; convert only arguments deliberately identified as paths before execution. Never retry blindly after failure. |
| `wslx info` | — | Print concise WSL/distro/kernel/interop information; read-only. |
| `wslx drives` | — | Show Windows drives and corresponding WSL mount points; read-only. |
| `wslx ports` | — | Show listening ports with PID/process context; read-only. |
| `wslx kill-port <port>` | — | Resolve target, show it, confirm, then send `SIGTERM`; force behavior requires an explicit option. |
| `wslx jump` | — | Integrate existing history/fuzzy tools for directory jumping instead of rebuilding them. |
| `wslx pick` | — | Return an interactively selected path using `fd/find` + optional `fzf`. |
| `wslx update` | — | Update from a validated source/release, run validation, then reinstall. |
| `wslx config` | — | Manage stable WSLX preferences without manual `.bashrc` edits. |


## Current-shell command rule

`wslx cd` is special because a child process cannot change its parent Bash
shell. The child WSLX process only calculates the normalized destination
and exits. The parent Bash process then runs its own `cd` builtin, which
ultimately uses `chdir(2)`.

## Composition rule

```text
path  -> translate/normalize
cd    -> navigate
open  -> open with Windows
clip  -> clipboard
run   -> execute
```

Commands should do one understandable job and compose instead of accumulating
unrelated side effects.
