# WSLX Architecture

## Foundation principle

WSLX is split into **entry point**, **feature commands**, **shared libraries**,
**shell integration**, **installation**, **tests**, and **living documentation**.
A feature should not bypass these boundaries just because a one-line shell
shortcut would be faster to write.

## Execution model

```text
User
  |
  v
bin/wslx                 <- parse + dispatch only
  |
  +--> commands/*.sh     <- feature behavior
  |
  +--> lib/*.sh          <- reusable logic / UI
  |
  +--> shell/bash/*      <- only when parent-shell state must change
```

## CLI contract

`docs/COMMANDS.md` is the naming contract.

Canonical behavior lives under one namespace:

```text
wslx path
wslx cd
wslx open
wslx clip
wslx run
```

Only frequent shell actions may gain a `w<command>` convenience alias such as
`wcd` or `wopen`. Rare commands stay under `wslx` only.

This follows familiar Unix CLI habits: short lowercase command names, operands
for input values, standard `--help`/`--version`, and readable long options.

## Path interoperability rule

The default path command returns a path usable in WSL:

```text
Windows input -> convert with wslpath to WSL form
WSL input     -> keep unchanged
```

The user must explicitly request Windows form with `--win`.

`--link` is presentation only. It converts to Windows form and, when stdout is
an interactive terminal, wraps the displayed path in an OSC-8 `file://`
hyperlink. Captured or piped output remains plain text.

This keeps path output composable and avoids surprising direction changes.

## Safe path rule

Future path-aware execution must inspect/convert path arguments **before** the
target program executes. WSLX must never blindly retry an arbitrary command
after failure because the first attempt may already have produced side effects.

## Shell-state rule

A child executable cannot change the parent Bash process's working directory.
Therefore commands such as future `wslx cd` / `wcd` are implemented through
`shell/bash/wslx.bash`, while their path-normalization logic remains reusable.

## Windows interop rule

WSLX uses Windows executables exposed by WSL when they are the correct backend.
For example, Microsoft documents launching Windows executables directly from
WSL and using `explorer.exe .` to open the current Linux directory in Explorer.
Future `wslx open` will build on that bridge rather than inventing another one.

## Installation model

The default install is per-user and does not require `sudo`:

```text
~/.local/bin/wslx
~/.local/share/wslx/
~/.local/share/man/man1/wslx.1
```

The installer owns exactly one marked block in `.bashrc`. The uninstaller may
remove that block, but must preserve unrelated user content.

## Documentation invariant

`docs/MAP.md` is the canonical structural map. Any change that adds, removes,
renames, or changes the responsibility of a sector/file updates the map in the
same change. `tests/test-map.sh` catches newly added structural files that are
not indexed.
