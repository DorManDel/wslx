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
  +--> commands/*.sh     <- feature behavior (starts WSLX-002)
  |
  +--> lib/*.sh          <- reusable logic / UI
  |
  +--> shell/bash/*      <- only when parent-shell state must change
```

## Smart path rule

Future smart-path behavior must convert/validate path arguments **before** a
command executes. WSLX must not blindly rerun arbitrary commands after failure,
because the first attempt may already have produced side effects.

## Installation model

The default install is per-user and does not require `sudo`:

```text
~/.local/bin/wslx
~/.local/share/wslx/
~/.local/share/man/man1/wslx.1
```

The installer owns exactly one marked block in `.bashrc`. The uninstaller may
remove that block, but must preserve all unrelated user content.

## Documentation invariant

`docs/MAP.md` is the canonical "Mapxplanation". Any change that adds, removes,
renames, or changes the responsibility of a sector/file must update that map in
the same change. `tests/test-map.sh` catches newly added structural files that
were not indexed.
