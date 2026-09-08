# WSLX Current State

Version: `0.1.0-dev`  
Phase: **WSLX-002 — Path Interop final refinement**

## WSLX-001 — Foundation

Status: **COMPLETE**

Foundation, installer/uninstaller, shell integration, completion foundation,
Mapxplanation, portability rules and clean-clone validation are complete.

## WSLX-002 — Path Interop

Status: **IN PROGRESS — FINAL GATE**

Goal: make Windows/WSL paths predictable and easy to use from WSL.

### Current interface

```bash
wslx <path>
wslx path <path>
wslx --wsl <path>
wslx --win <path>
wslx --link <path>
```

### Completed

- [x] Windows input normalizes to WSL by default
- [x] WSL input stays usable in WSL by default
- [x] direct `wslx <path>` shortcut
- [x] explicit `wslx path <path>` form
- [x] `--wsl`, `--win`, `--link`
- [x] interactive `--link` confirmed clickable in the user's VS Code WSL terminal
- [x] plain-text `--link` fallback for captured output
- [x] CLI grammar documented in `docs/COMMANDS.md`
- [x] future command naming/contracts normalized
- [x] README command table and workflow sections redesigned
- [x] WSLX SVG logo added
- [x] command-document contract template standardized
- [x] colored test assertions and suite summary prepared
- [x] failed-suite output includes exit code and rerun command

### Last validated Path Interop baseline

- [x] Foundation: 3 passed, 0 failed
- [x] Installer: 13 passed, 0 failed
- [x] Map: 33 passed, 0 failed
- [x] Path: 14 passed, 0 failed
- [x] ShellCheck passed
- [x] `git diff --check` passed
- [x] installed smoke tests passed

### Remaining after applying this refinement batch

- [ ] run final `make check`
- [ ] run final `git diff --check`
- [ ] inspect `git status -sb`
- [ ] commit and push PR #1

Current step: apply the final README/logo/test-UX refinement and run the final
gate before commit.
