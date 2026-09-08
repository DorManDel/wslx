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
|   `-- wslx             locate -> load -> parse -> dispatch
|
|-- commands/            FEATURE BEHAVIOR
|   |-- README.md        command-module contract
|   `-- path.sh          Windows ↔ WSL PathX command
|
|-- lib/                 SHARED LOGIC
|   |-- core.sh          environment/version/common command helpers
|   `-- ui.sh            colors/status/error presentation
|
|-- shell/               PARENT-SHELL INTEGRATION
|   `-- bash/
|       `-- wslx.bash    future parent-shell features
|
|-- completions/         TAB COMPLETION
|   `-- bash/wslx        top-level commands + PathX options
|
|-- scripts/             DEVELOPER AUTOMATION
|   `-- new-change.sh    timestamped engineering record generator
|
|-- tests/               AUTOMATED SAFETY NET
|   |-- run.sh           executes every test suite
|   |-- testlib.sh       shared dependency-free assertions
|   |-- test-foundation.sh
|   |-- test-install.sh  install/uninstall + installed PathX
|   |-- test-map.sh      enforces this living map
|   `-- test-path.sh     PathX command behavior
|
|-- docs/                EXPLANATION + CONTINUITY
|   |-- MAP.md           canonical structural map
|   |-- FOLDERS.md       folder ownership / code-placement guide
|   |-- ARCHITECTURE.md  system boundaries and design rules
|   |-- DEVELOPMENT.md   development workflow
|   |-- CURRENT_STATE.md current completed/active task
|   |-- ROADMAP.md       future command catalog
|   |-- commands/
|   |   |-- README.md    command-documentation contract
|   |   `-- path.md      PathX detailed explanation
|   `-- changes/         timestamped engineering records
|
|-- man/                 TERMINAL REFERENCE DOCS
|   `-- wslx.1           terminal manual page
|
|-- install.sh           per-user installer
|-- uninstall.sh         safe package removal
|-- Makefile             developer control panel
|-- VERSION              package version
|-- README.md            quick start / install / basic usage
|-- CHANGELOG.md         release-level history
|-- LICENSE              project license
|-- .gitattributes       Git text / line-ending policy
`-- .gitignore           local/generated file exclusions
```

## 2. Sector responsibilities

| Sector | Simple meaning | Detailed responsibility |
|---|---|---|
| `bin/` | Entry point. | Contains the executable a user invokes. It locates WSLX, loads shared libraries and feature modules, parses top-level arguments, and dispatches commands. |
| `commands/` | Feature behavior. | One module per user-facing command. PathX lives here so feature logic does not accumulate inside the main dispatcher. |
| `lib/` | Reusable logic. | Shared helpers used by multiple parts of WSLX, such as environment detection, version handling, UI, and errors. |
| `shell/` | Parent-shell behavior. | Functions that must execute inside the user's current shell because a child process cannot modify parent-shell state. |
| `completions/` | TAB completion. | Shell-specific completion rules for WSLX commands and command-specific options. |
| `scripts/` | Developer automation. | Maintainer tools such as timestamped change-record creation. |
| `tests/` | Automatic proof. | Verifies CLI behavior, PathX conversion, installation, installed execution, uninstall safety, and structural documentation rules. |
| `docs/` | Project knowledge. | Architecture, folder ownership, workflow, current state, feature explanations, roadmap, and historical change records. |
| `man/` | Terminal reference. | Short manual documentation intended for installed users. |
| repository root | Lifecycle/control. | Installation, uninstall, Make targets, versioning, Git policy, README, changelog, license, and repository hygiene. |

## 3. File-by-file explanation

| File | Why it exists |
|---|---|
| `.gitattributes` | Defines repository text and line-ending portability rules across Windows and WSL. |
| `.gitignore` | Keeps personal editor state, temporary files, and generated/local noise outside Git history. |
| `VERSION` | Single source for the current WSLX version. |
| `LICENSE` | Defines project reuse and distribution terms. |
| `README.md` | Short user guide covering clone/install, PathX basics, update, uninstall, and the development check command. |
| `CHANGELOG.md` | Release-level project history. |
| `Makefile` | Developer control surface for tests, lint, checks, install, uninstall, doctor, and change records. |
| `install.sh` | Installs WSLX into the per-user prefix, including shared libraries, PathX, shell integration, completion, documentation, and manual files. |
| `uninstall.sh` | Removes WSLX-owned files and its managed Bash block while preserving unrelated user configuration. |
| `bin/wslx` | Main CLI executable and dispatcher. Loads shared libraries and feature modules, including PathX. |
| `commands/README.md` | Defines the command-module boundary and rules for feature implementations. |
| `commands/path.sh` | Implements PathX conversion, automatic direction detection, explicit modes, argument validation, errors, and help. |
| `lib/core.sh` | Shared WSL environment, version, and command-presence helpers. |
| `lib/ui.sh` | Shared status, warning, error, and color presentation. |
| `shell/bash/wslx.bash` | Bash integration for features that must execute in the current shell. |
| `completions/bash/wslx` | Bash completion for WSLX top-level commands and PathX-specific options. |
| `scripts/new-change.sh` | Generates timestamped `docs/changes/*.md` engineering records. |
| `tests/run.sh` | Finds and executes each `test-*.sh` test suite and combines their status. |
| `tests/testlib.sh` | Minimal shared assertion helpers used by the test suites. |
| `tests/test-foundation.sh` | Verifies version, help, and unknown-command foundation behavior. |
| `tests/test-install.sh` | Verifies installation layout, PathX packaging, installed PathX execution, idempotence, and safe uninstall. |
| `tests/test-map.sh` | Ensures every Git-relevant structural file is indexed in this Mapxplanation while respecting `.gitignore`. |
| `tests/test-path.sh` | Verifies automatic and explicit PathX conversion, spaces, errors, and help behavior. |
| `docs/MAP.md` | Canonical living structural and responsibility map. |
| `docs/FOLDERS.md` | Explains what each project directory owns and where new code belongs. |
| `docs/ARCHITECTURE.md` | Records system boundaries and architecture decisions. |
| `docs/DEVELOPMENT.md` | Defines the WSLX development and validation workflow. |
| `docs/CURRENT_STATE.md` | Records completed work and the currently active task. |
| `docs/ROADMAP.md` | Catalog of future WSLX commands and capabilities. |
| `docs/commands/README.md` | Template and contract for command-specific documentation. |
| `docs/commands/path.md` | Detailed PathX command contract, behavior, detection rules, errors, examples, and flow. |
| `man/wslx.1` | Short terminal manual for WSLX. |

`docs/changes/*.md` are timestamped instances of one documented history format.
They are treated as a directory sector instead of requiring one MAP row for
every generated timestamp.

## 4. PathX control flow

```text
user
 |
 |  wslx path ...
 v
bin/wslx
 |
 +--> lib/core.sh
 |
 +--> lib/ui.sh
 |
 v
top-level dispatcher
 |
 |  command = path
 v
commands/path.sh
 |
 +--> parse PathX options
 |
 +--> validate one path argument
 |
 +--> verify wslpath exists
 |
 +--> automatic detection
 |       |
 |       +--> Windows path -> wslpath -u
 |       |
 |       `--> WSL path     -> wslpath -w
 |
 `--> explicit mode
         |
         +--> --to-wsl     -> wslpath -u
         |
         `--> --to-windows -> wslpath -w
 |
 v
converted path
```

## 5. Installed package flow

```text
repository
    |
    v
install.sh
    |
    +--> ~/.local/bin/wslx
    |
    `--> ~/.local/share/wslx/
            |
            |-- commands/path.sh
            |
            |-- lib/core.sh
            |-- lib/ui.sh
            |
            |-- shell/bash/wslx.bash
            |
            `-- completions/bash/wslx
```

`tests/test-install.sh` verifies that PathX is copied into this layout and that
the installed executable can successfully execute the PathX command.

## 6. Shell completion flow

```text
Bash startup
    |
    v
~/.bashrc
    |
    v
WSLX managed block
    |
    +--> shell/bash/wslx.bash
    |
    `--> completions/bash/wslx
                |
                +--> wslx pa<TAB>
                |       -> path
                |
                `--> wslx path --to<TAB>
                        -> --to-wsl
                        -> --to-windows
```

## 7. Update rule

A WSLX feature is incomplete until every affected layer is updated.

For WSLX-002 — PathX:

```text
commands/path.sh            implementation
bin/wslx                    dispatch
install.sh                  installed packaging
completions/bash/wslx       discoverability
tests/test-path.sh           behavior proof
tests/test-install.sh        installed-package proof
docs/commands/path.md        feature explanation
docs/FOLDERS.md              folder ownership reference
docs/MAP.md                  structural/responsibility map
docs/CURRENT_STATE.md        current progress
docs/changes/<timestamp>     historical what/why/result
```

Validation gate:

```text
make check
    |
    +--> automated tests
    |
    +--> Mapxplanation verification
    |
    `--> ShellCheck
```
