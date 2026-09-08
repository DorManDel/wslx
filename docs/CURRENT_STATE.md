# WSLX Current State

Version: `0.1.0-dev`  
Phase: **WSLX-002 — PathX**

## WSLX-001 — Foundation Commit

Status: **COMPLETE**

- [x] Git repository skeleton
- [x] CLI entry point
- [x] shared core/UI libraries
- [x] living Mapxplanation
- [x] command roadmap
- [x] timestamped change-record workflow
- [x] dependency-free automated tests
- [x] `Makefile` convenience commands
- [x] per-user installer
- [x] safe/idempotent Bash managed block
- [x] one-command installed uninstall (`wslx uninstall`)
- [x] Bash completion foundation
- [x] basic man page
- [x] Windows/WSL Git line-ending policy via `.gitattributes`
- [x] Windows-mounted NTFS file-mode behavior documented
- [x] ShellCheck integrated into the developer validation gate
- [x] Foundation shell code passes ShellCheck
- [x] real WSL validation: tests, lint, and `wslx doctor`


## Foundation validation

Status: **COMPLETE**

- [x] published to GitHub
- [x] fresh GitHub clone
- [x] clean-clone `make check`
- [x] install from fresh clone
- [x] installed `wslx version`
- [x] installed `wslx doctor`
- [x] uninstall
- [x] reinstall

## WSLX-002 — PathX

Status: **IN PROGRESS**

Goal: implement Windows ↔ WSL path conversion as the first real WSLX feature.

### Command interface

```bash
wslx path <path>
wslx path --to-wsl <path>
wslx path --to-windows <path>
```

### Completed

- [x] PathX command module created
- [x] dispatcher integration
- [x] automatic Windows → WSL conversion
- [x] automatic WSL → Windows conversion
- [x] explicit `--to-wsl`
- [x] explicit `--to-windows`
- [x] paths containing spaces
- [x] command help
- [x] argument/error tests
- [x] installer copies PathX command module
- [x] PathX tests pass from the development checkout
- [x] installed PathX execution test
- [x] Bash completion update
- [x] `docs/commands/path.md`
- [x] Mapxplanation updated for PathX structure

### Validation

- [x] installer test: 11 passed, 0 failed
- [x] map test: 32 passed, 0 failed
- [x] PathX test: 8 passed, 0 failed
- [x] Foundation test: 3 passed, 0 failed
- [x] ShellCheck
- [x] `git diff --check`
- [x] final `make check`

WSLX-002 — PathX is complete.

Current step: review, commit, push, and merge the PathX branch.