# WSLX Mapxplanation

> **Living contract:** this file is part of the implementation. Whenever we add,
> remove, rename, or change the responsibility of a sector/file, we update this
> map in the same change. `tests/test-map.sh` checks that structural files are
> indexed here.

## 1. Project map

```text
wslx/
|
|-- bin/                 ENTRY POINT
|   `-- wslx             parse -> load core -> dispatch
|
|-- commands/            FEATURE BEHAVIOR
|   `-- README.md        command-module contract; PathX starts WSLX-002
|
|-- lib/                 SHARED LOGIC
|   |-- core.sh          environment/version/common command helpers
|   `-- ui.sh            colors/status/error presentation
|
|-- shell/               PARENT-SHELL INTEGRATION
|   `-- bash/
|       `-- wslx.bash    future wcd/smart-cd style functions
|
|-- completions/         TAB COMPLETION
|   `-- bash/wslx        completion for current WSLX commands
|
|-- scripts/             DEVELOPER AUTOMATION
|   `-- new-change.sh    timestamped engineering record generator
|
|-- tests/               AUTOMATED SAFETY NET
|   |-- run.sh           executes every test suite
|   |-- testlib.sh       tiny dependency-free assertions
|   |-- test-foundation.sh
|   |-- test-install.sh
|   `-- test-map.sh      enforces this living map
|
|-- docs/                EXPLANATION + CONTINUITY
|   |-- MAP.md           this canonical map
|   |-- ARCHITECTURE.md  system boundaries and design rules
|   |-- DEVELOPMENT.md   how every change is performed
|   |-- CURRENT_STATE.md current completed/next task
|   |-- ROADMAP.md       future command idea catalog
|   |-- commands/        deep command explanations
|   `-- changes/         timestamped engineering records
|
|-- man/                 TERMINAL REFERENCE DOCS
|   `-- wslx.1           basic man page
|
|-- install.sh           one-command source-checkout installer
|-- uninstall.sh         safe package removal
|-- Makefile             developer control panel
|-- VERSION              single package version value
|-- README.md            user-facing project introduction
|-- CHANGELOG.md         release-level summary history
|-- LICENSE              project license
├── .gitattributes       Git text / line-ending portability policy
`-- .gitignore           excludes local/generated noise
```

## 2. Sector responsibilities

| Sector | Simple meaning | Detailed responsibility |
|---|---|---|
| `bin/` | Entry point. | Contains the executable a user invokes. It should locate WSLX, load libraries, parse top-level arguments and dispatch; feature logic should not accumulate here. |
| `commands/` | What each command does. | One module per real feature such as path/open/clip. Commands orchestrate shared libraries and external tools while keeping feature-specific behavior isolated. |
| `lib/` | Reusable building blocks. | Common logic used by multiple commands: WSL detection, path primitives, UI/error helpers and later process/config helpers. |
| `shell/` | Things only Bash itself can do. | Functions that must modify parent-shell state, such as `wcd`. We source one package-owned file instead of injecting many functions directly into `.bashrc`. |
| `completions/` | TAB knows WSLX. | Shell-specific completion definitions so commands/options can be discovered interactively without memorization. |
| `scripts/` | Tools for developing WSLX. | Automation used by maintainers, not normal end users: change-record creation, future release helpers, documentation validation, etc. |
| `tests/` | Automatic proof. | Dependency-free checks for CLI contracts, installation safety, idempotence, uninstall cleanup and documentation-map discipline. |
| `docs/` | Why the project is built this way. | Architecture, current state, workflow, command teaching documents and timestamped continuity records. Detailed learning explanations live here rather than overcrowding production source. |
| `man/` | Fast terminal manual. | Concise reference designed for `man wslx`; it complements, rather than replaces, the deeper docs. |
| repository root | Lifecycle/control. | Install/uninstall, Make targets, versioning, Git portability policy, user README, changelog, license and repository hygiene. |

## 3. File-by-file explanation

| File | Why it exists |
|---|---|
| `.gitattributes` | Defines Git text and line-ending portability rules across Windows and WSL. It normalizes repository text and forces Linux-oriented files such as `.sh` and `.bash` to use LF. It does not control Unix executable permissions; mode-only NTFS changes are handled locally with `git config core.fileMode false`. |
| `.gitignore` | Keeps editor, OS, temporary test and local environment noise out of Git history. |
| `VERSION` | Single source for the current WSLX version used by CLI/docs/installations. |
| `LICENSE` | Defines legal reuse/distribution terms; Foundation uses MIT. |
| `README.md` | First page for a user: what WSLX is, how to validate, install and uninstall it. |
| `CHANGELOG.md` | Human-readable release-level summary; detailed timestamp logs stay under `docs/changes/`. |
| `Makefile` | Easy control surface: `make test`, `check`, `install`, `uninstall`, `doctor`, `change`. |
| `install.sh` | Detects WSL, copies files into the per-user prefix, creates one managed Bash block, and supports safe repeat installation. |
| `uninstall.sh` | Removes only WSLX-owned files plus the managed Bash block while preserving unrelated user configuration. |
| `bin/wslx` | Main executable and dispatcher. Foundation exposes `help`, `version`, `doctor`, and installed `uninstall`. |
| `commands/README.md` | Documents the command-module boundary before the first real module arrives in WSLX-002. |
| `lib/core.sh` | Shared environment/version/command-presence primitives with no UI concerns. |
| `lib/ui.sh` | Shared colored status/error output, automatically disabled for non-terminal output or `NO_COLOR`. |
| `shell/bash/wslx.bash` | Single Bash integration source file; future shell-state functions live here. |
| `completions/bash/wslx` | Bash completion for the current top-level command set. |
| `scripts/new-change.sh` | Generates timestamped `docs/changes/*.md` records in the machine's local timezone. |
| `tests/run.sh` | Finds and runs each `test-*.sh` suite and combines their exit status. |
| `tests/testlib.sh` | Minimal assertion helpers so tests need no Bats/Python/npm dependency. |
| `tests/test-foundation.sh` | Verifies version/help/unknown-command behavior of the entry point. |
| `tests/test-install.sh` | Installs into a temporary HOME, tests idempotence, tests installed execution, then verifies safe uninstall. |
| `tests/test-map.sh` | Ensures every Git-relevant structural file (except timestamp log instances) is explicitly named in this Mapxplanation while respecting `.gitignore`. |
| `docs/MAP.md` | Canonical living architecture + sector + file explanation. |
| `docs/ARCHITECTURE.md` | Records boundaries, safe smart-path policy, installation model and map invariant. |
| `docs/DEVELOPMENT.md` | Defines the update discipline: record -> code -> tests -> docs/map -> check -> commit. |
| `docs/CURRENT_STATE.md` | Tiny continuity file showing completed foundation and the next numbered task. |
| `docs/ROADMAP.md` | Lists future command ideas with simple and detailed descriptions plus existing-tool inspiration. |
| `docs/commands/README.md` | Template/contract for the deep explanation page each real command will receive. |
| `man/wslx.1` | Short Unix man-page reference for the foundation CLI. |

`docs/changes/*.md` are timestamped instances of one documented log format and
are intentionally treated as a sector by the map-index test rather than forcing
the file table to grow on every timestamp.

## 4. Data/control flow

```text
                    user types: wslx ...
                             |
                             v
                        bin/wslx
                             |
                  +----------+----------+
                  |                     |
                  v                     v
               lib/core.sh           lib/ui.sh
                  |
          future dispatcher
                  |
                  v
              commands/*.sh
                  |
          Windows / Linux tools

Bash startup
    |
    v
managed .bashrc block
    |
    +--> shell/bash/wslx.bash
    `--> completions/bash/wslx
```

## 5. Update rule

A future change such as `WSLX-002 — PathX` is incomplete until all relevant
layers move together:

```text
commands/path.sh            implementation
lib/paths.sh                reusable path logic (if needed)
tests/test-path.sh          automated behavior
completions/bash/wslx       discoverability
docs/commands/path.md       deep explanation
docs/MAP.md                 map/responsibility update
docs/CURRENT_STATE.md       continuity
docs/changes/<timestamp>    what/when/why/validation
```
