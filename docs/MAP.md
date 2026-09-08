# WSLX Mapxplanation

> **Living contract:** this file is part of the implementation. Whenever we add,
> remove, rename, or change the responsibility of a sector/file, we update this
> map in the same change. `tests/test-map.sh` checks that structural files are
> indexed here.

## 1. Project map

```text
wslx/
|
|-- assets/              REPOSITORY VISUALS
|   `-- wslx-logo.svg    Windows ↔ WSL terminal mark
|
|-- bin/                 ENTRY POINT
|   `-- wslx             locate -> load -> parse -> dispatch
|
|-- commands/            FEATURE BEHAVIOR
|   |-- README.md        command-module contract
|   `-- path.sh          Windows/WSL path interoperability
|
|-- lib/                 SHARED LOGIC
|   |-- core.sh          environment/version/common command helpers
|   `-- ui.sh            colors/status/error presentation
|
|-- shell/               PARENT-SHELL INTEGRATION
|   `-- bash/
|       `-- wslx.bash    future current-shell commands such as cd/wcd
|
|-- completions/         TAB COMPLETION
|   `-- bash/wslx        top-level commands + path options
|
|-- scripts/             DEVELOPER AUTOMATION
|   `-- new-change.sh    timestamped engineering record generator
|
|-- tests/               AUTOMATED SAFETY NET
|   |-- run.sh           executes every test suite
|   |-- testlib.sh       shared dependency-free assertions
|   |-- test-foundation.sh
|   |-- test-install.sh  install/uninstall + installed path behavior
|   |-- test-map.sh      enforces this living map
|   `-- test-path.sh     path interoperability behavior
|
|-- docs/                EXPLANATION + CONTINUITY
|   |-- COMMANDS.md      CLI grammar, names, options and alias contract
|   |-- MAP.md           canonical structural map
|   |-- FOLDERS.md       folder ownership / code-placement guide
|   |-- ARCHITECTURE.md  system boundaries and design rules
|   |-- DEVELOPMENT.md   development workflow
|   |-- CURRENT_STATE.md current completed/active task
|   |-- ROADMAP.md       future command catalog
|   |-- commands/
|   |   |-- README.md    command-documentation contract
|   |   `-- path.md      path interoperability explanation
|   `-- changes/         timestamped engineering records
|
|-- man/                 TERMINAL REFERENCE DOCS
|   `-- wslx.1           terminal manual page
|
|-- install.sh           per-user installer
|-- uninstall.sh         safe package removal
|-- Makefile             developer control panel
|-- VERSION              package version
|-- README.md            quick start + command table
|-- CHANGELOG.md         release-level history
|-- LICENSE              project license
|-- .gitattributes       Git text / line-ending policy
`-- .gitignore           local/generated file exclusions
```

## 2. Sector responsibilities

| Sector | Simple meaning | Detailed responsibility |
|---|---|---|
| `assets/` | Repository visuals. | Small tracked visual assets used by project documentation and branding; no runtime behavior lives here. |
| `bin/` | Entry point. | Locates WSLX, loads libraries/modules, recognizes top-level commands or direct path operands, and dispatches. |
| `commands/` | Feature behavior. | One module per user-facing feature. `path.sh` owns path normalization, explicit Windows/WSL forms, and hyperlink presentation. |
| `lib/` | Reusable logic. | Shared environment/version/UI helpers used by multiple commands. |
| `shell/` | Parent-shell behavior. | Functions that must modify the current Bash process, such as future `wslx cd` / `wcd`. |
| `completions/` | TAB completion. | Bash completion for canonical commands and command-specific options. |
| `scripts/` | Developer automation. | Maintainer helpers such as timestamped change-record creation. |
| `tests/` | Automatic proof. | Verifies CLI behavior, path semantics, installation, installed execution, uninstall safety, and structural documentation rules. |
| `docs/` | Project knowledge. | CLI contract, architecture, folder ownership, workflow, current state, feature explanations, roadmap, and change history. |
| `man/` | Terminal reference. | Concise installed-user reference. |
| repository root | Lifecycle/control. | Install/uninstall, Make targets, versioning, README, changelog, Git policy, and repository hygiene. |

## 3. File-by-file explanation

| File | Why it exists |
|---|---|
| `assets/wslx-logo.svg` | Purple/magenta Windows ↔ shell mark used by the repository README. |
| `.gitattributes` | Defines repository text/line-ending portability rules across Windows and WSL. |
| `.gitignore` | Keeps personal editor state, temporary files, and generated/local noise outside Git history. |
| `VERSION` | Single source for the current WSLX version. |
| `LICENSE` | Defines project reuse and distribution terms. |
| `README.md` | Human-facing clone/install guide plus a short table of current and near-term commands. |
| `CHANGELOG.md` | Release-level project history, including WSLX-002 Path Interop. |
| `Makefile` | Developer control surface; `make check` runs tests and ShellCheck and prints a final colored PASS/FAIL summary. |
| `install.sh` | Installs the executable, shared libraries, path module, shell integration, completion, key docs, and man page. |
| `uninstall.sh` | Removes WSLX-owned files and its managed Bash block while preserving unrelated user configuration. |
| `bin/wslx` | Main CLI dispatcher. Supports canonical commands, direct path operands, and top-level path options. |
| `commands/README.md` | Defines the command-module boundary and planned module style. |
| `commands/path.sh` | Implements default normalize-for-WSL behavior plus `--wsl`, `--win`, and `--link`. |
| `lib/core.sh` | Shared WSL environment, version, and command-presence helpers. |
| `lib/ui.sh` | Shared status, warning, error, and color presentation. |
| `shell/bash/wslx.bash` | Bash integration reserved for features that must affect the current shell. |
| `completions/bash/wslx` | Bash completion for top-level commands/options and path-specific options. |
| `scripts/new-change.sh` | Generates timestamped `docs/changes/*.md` engineering records. |
| `tests/run.sh` | Finds and executes each `test-*.sh` suite and combines status. |
| `tests/testlib.sh` | Minimal shared assertion helpers. |
| `tests/test-foundation.sh` | Verifies version/help/unknown-command foundation behavior. |
| `tests/test-install.sh` | Verifies installation layout, CLI grammar doc packaging, installed path semantics, idempotence, and safe uninstall. |
| `tests/test-map.sh` | Ensures every Git-relevant structural file is indexed here while respecting `.gitignore`. |
| `tests/test-path.sh` | Verifies default/explicit path semantics, direct path shortcuts, link fallback, spaces, errors, and help. |
| `docs/COMMANDS.md` | Canonical CLI grammar, naming policy, option names, alias policy, current commands, and planned command names. |
| `docs/MAP.md` | Canonical living structural/responsibility map. |
| `docs/FOLDERS.md` | Explains directory ownership and where new code belongs. |
| `docs/ARCHITECTURE.md` | Records module boundaries, path semantics, shell-state rules, and Windows interop design. |
| `docs/DEVELOPMENT.md` | Defines the WSLX development/update discipline. |
| `docs/CURRENT_STATE.md` | Shows completed work and the active numbered task. |
| `docs/ROADMAP.md` | Future command catalog using the canonical command language. |
| `docs/commands/README.md` | Contract for command-specific explanation documents. |
| `docs/commands/path.md` | Detailed explanation of current path interoperability behavior. |
| `man/wslx.1` | Short terminal manual for current WSLX behavior. |

`docs/changes/*.md` are timestamped instances of one documented history format.
They are treated as a sector instead of requiring a MAP row for every record.

## 4. CLI grammar

Canonical command form:

```text
wslx <command> [options] [operands]
```

Path interoperability has one direct convenience form:

```text
wslx <path>
```

High-frequency future shell actions may also expose `w<command>` aliases such
as `wcd` and `wopen`. The canonical command remains under `wslx`.

The detailed naming contract lives in `docs/COMMANDS.md`.

## 5. Path control flow

Default behavior:

```text
user input
   |
   +--> wslx <path>
   |        or
   `--> wslx path <path>
            |
            v
         bin/wslx
            |
            v
     commands/path.sh
            |
      +-----+------------------+
      |                        |
Windows drive path        WSL/Linux path
      |                        |
      v                        v
  wslpath -u              return unchanged
      |                        |
      +-----------+------------+
                  |
                  v
          path usable in WSL
```

Explicit Windows form:

```text
wslx --win <path>
        |
        v
commands/path.sh
        |
        +--> already Windows -> unchanged
        `--> WSL/Linux       -> wslpath -w
```

Clickable presentation:

```text
wslx --link <path>
        |
        v
Windows representation
        |
        +--> interactive stdout -> OSC-8 file:// hyperlink
        `--> pipe/capture       -> plain Windows path
```

## 6. Installed package flow

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
            |-- lib/core.sh
            |-- lib/ui.sh
            |-- shell/bash/wslx.bash
            |-- completions/bash/wslx
            `-- docs/COMMANDS.md
```

`tests/test-install.sh` verifies both package layout and installed path behavior.

## 7. Next command boundaries

The path command translates; action commands remain separate:

```text
wslx path             translate/normalize
wslx cd    / wcd      navigate current shell       (planned)
wslx open  / wopen    open with Windows            (planned)
wslx clip  / wclip    clipboard                    (planned)
wslx run   / wrun     execute Windows program      (planned)
```

`wslx cd` belongs partly in `shell/` because a child executable cannot change
the parent Bash process.

## 8. Update rule

WSLX-002 — Path Interop moves these layers together:

```text
commands/path.sh            path behavior
bin/wslx                    direct-path/top-level dispatch
completions/bash/wslx       discoverability
install.sh                  installed packaging
tests/test-path.sh           behavior proof
tests/test-install.sh        installed-package proof
README.md                    short user guide
docs/COMMANDS.md             CLI naming/grammar contract
docs/commands/path.md        deep feature explanation
docs/ROADMAP.md              future names and scope
docs/ARCHITECTURE.md         design rules
docs/FOLDERS.md              directory ownership reference
docs/MAP.md                  structural/responsibility map
docs/CURRENT_STATE.md        continuity
assets/wslx-logo.svg          repository visual identity
docs/changes/<timestamp>     historical what/why/result
man/wslx.1                   terminal reference
CHANGELOG.md                 release-level summary
```

Validation gate remains:

```text
make check
    |
    +--> automated tests
    +--> Mapxplanation verification
    `--> ShellCheck
```
