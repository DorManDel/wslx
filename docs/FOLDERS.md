# WSLX Folder Guide

This document explains what each WSLX directory owns and where new code belongs.

## `assets/`

**Purpose:** repository-facing visual assets.

Current contents:

- `wslx-logo.svg` — WSLX Windows/WSL terminal mark used by the README.

---

## `bin/`

**Purpose:** executable entry points and top-level dispatch.

- `bin/wslx` — main WSLX CLI.

Feature implementations belong in `commands/`; `bin/wslx` stays focused on
startup, loading, top-level parsing and dispatch.

---

## `commands/`

**Purpose:** user-facing WSLX feature implementations.

- `README.md` — command-module rules.
- `path.sh` — Windows/WSL path interoperability.

Future examples include `open.sh`, `clip.sh` and `run.sh`.

---

## `lib/`

**Purpose:** reusable logic shared by multiple commands.

- `core.sh` — environment, version and common command helpers.
- `ui.sh` — output, colors, warnings and errors.

---

## `shell/`

**Purpose:** behavior that must execute in the user's current shell.

- `shell/bash/wslx.bash` — implements current-shell `wslx cd` handling and the `wcd` shortcut.

---

## `completions/`

**Purpose:** shell TAB completion.

- `completions/bash/wslx`

Update this when commands or options are added or renamed.

---

## `tests/`

**Purpose:** automated verification and developer-facing test output.

- `run.sh` — runs every suite and prints the final suite summary/references.
- `testlib.sh` — shared assertions and colored PASS/FAIL output.
- `test-foundation.sh` — foundation CLI behavior.
- `test-install.sh` — installation lifecycle and installed path behavior.
- `test-map.sh` — structural documentation contract.
- `test-path.sh` — path interoperability behavior.
- `test-cd.sh` — parent-shell `wslx cd` / `wcd` behavior.

---

## `scripts/`

**Purpose:** developer automation.

- `new-change.sh` — creates timestamped engineering records.

---

## `docs/`

**Purpose:** project knowledge, contracts and explanations.

Important files:

- `COMMANDS.md` — CLI grammar, naming, aliases and command contracts.
- `MAP.md` — living architecture and structural map.
- `FOLDERS.md` — this folder ownership guide.
- `ARCHITECTURE.md` — architecture and system boundaries.
- `DEVELOPMENT.md` — development workflow.
- `CURRENT_STATE.md` — current project state.
- `ROADMAP.md` — planned features.

### `docs/commands/`

Command contract template plus deep explanations for implemented commands.

### `docs/changes/`

Timestamped engineering records describing what changed, why, validation,
result and next step.

---

## `man/`

**Purpose:** Unix manual pages.

- `wslx.1`

---

## Repository root

Project lifecycle/configuration files live here, including `install.sh`,
`uninstall.sh`, `Makefile`, `VERSION`, `README.md`, `CHANGELOG.md`, `.gitignore`
and `.gitattributes`.

## Quick placement rule

```text
Visual/repository asset?  -> assets/
User-facing command?      -> commands/
Reusable logic?           -> lib/
Current-shell behavior?   -> shell/
TAB completion?           -> completions/
Automated verification?   -> tests/
Developer automation?     -> scripts/
CLI/naming contract?      -> docs/COMMANDS.md
Detailed explanation?     -> docs/
Terminal manual?          -> man/
CLI startup / dispatcher? -> bin/
```
