# WSLX Folder Guide

This document explains what each WSLX directory owns and where new code belongs.

## `bin/`

**Purpose:** executable entry points.

Current contents:

- `bin/wslx` — main WSLX CLI.

Put code here when it is responsible for starting WSLX, loading modules,
parsing top-level commands, or dispatching commands.

Feature implementations belong in `commands/`.

---

## `commands/`

**Purpose:** user-facing WSLX feature implementations.

Current contents:

- `README.md` — command-module rules.
- `path.sh` — PathX Windows ↔ WSL path conversion.

Future examples:

- `open.sh`
- `clip.sh`

One user-facing command should normally have one command module here.

---

## `lib/`

**Purpose:** reusable logic shared by multiple commands.

Current contents:

- `core.sh` — environment, version, and common command helpers.
- `ui.sh` — output, colors, warnings, and errors.

Put logic here when multiple features need it.

---

## `shell/`

**Purpose:** functionality that must execute inside the user's current shell.

Current contents:

- `shell/bash/wslx.bash`

Example future feature:

- `wcd`

This directory is used when WSLX needs to modify parent-shell state.

---

## `completions/`

**Purpose:** shell TAB completion.

Current contents:

- `completions/bash/wslx`

Update this when commands or options are added.

---

## `tests/`

**Purpose:** automated verification.

Current contents:

- `run.sh` — runs all test suites.
- `testlib.sh` — shared assertions.
- `test-foundation.sh` — foundation CLI behavior.
- `test-install.sh` — installation lifecycle.
- `test-map.sh` — Mapxplanation structural contract.
- `test-path.sh` — PathX behavior.

Every feature or bug fix should receive automated coverage here when possible.

---

## `scripts/`

**Purpose:** developer automation.

Current contents:

- `new-change.sh` — creates timestamped engineering records.

These tools help maintain WSLX rather than serving normal CLI users.

---

## `docs/`

**Purpose:** project knowledge and explanations.

Important files:

- `MAP.md` — living architecture and structural map.
- `FOLDERS.md` — this folder ownership guide.
- `ARCHITECTURE.md` — architecture and system boundaries.
- `DEVELOPMENT.md` — development workflow.
- `CURRENT_STATE.md` — current project state.
- `ROADMAP.md` — planned features.

### `docs/commands/`

Detailed explanation of individual WSLX commands.

Current PathX document:

- `docs/commands/path.md`

### `docs/changes/`

Timestamped engineering records containing:

- what changed;
- why it changed;
- validation;
- result;
- next step.

---

## `man/`

**Purpose:** Unix manual pages.

Current contents:

- `wslx.1`

---

## Repository root

Project-level lifecycle and configuration files live here.

Current examples:

- `install.sh`
- `uninstall.sh`
- `Makefile`
- `VERSION`
- `README.md`
- `CHANGELOG.md`
- `.gitignore`
- `.gitattributes`

---

## Quick placement rule

```text
User-facing command?
    -> commands/

Reusable logic?
    -> lib/

Current-shell behavior?
    -> shell/

TAB completion?
    -> completions/

Automated verification?
    -> tests/

Developer automation?
    -> scripts/

Documentation?
    -> docs/

Terminal manual?
    -> man/

CLI startup / dispatcher?
    -> bin/
```