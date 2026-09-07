# WSLX Current State

Version: `0.1.0-dev`  
Phase: **Foundation**

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


## Active command set

- `wslx help`
- `wslx version`
- `wslx doctor`
- `wslx uninstall`

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

## Next feature

**WSLX-002 — PathX**

Implement the first real feature module: Windows ↔ WSL path conversion, with
unit tests and `docs/commands/path.md` line-by-line explanation.
