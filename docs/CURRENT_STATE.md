
# WSLX Current State

Version: `0.1.0-dev`
Phase: **WSLX-003 — CD / WCD validation**

## WSLX-001 — Foundation

Status: **COMPLETE**

## WSLX-002 — Path Interop

Status: **COMPLETE — MERGED TO MAIN**

## WSLX-003 — CD / WCD

Status: **IN PROGRESS — VALIDATION**

Interface:

```bash
wslx cd <path>
wcd <path>
```

Implemented:

- [x] parent-shell implementation
- [x] canonical `wslx cd`
- [x] shortcut `wcd`
- [x] Path Interop reuse
- [x] directory validation
- [x] direct-child refusal
- [x] Bash completion
- [x] `tests/test-cd.sh`
- [x] installed shell-integration coverage
- [x] command/architecture/MAP documentation

Execution model:

```text
child WSLX
  -> calculates normalized destination
  -> prints it
  -> exits

parent Bash
  -> receives destination
  -> runs builtin cd
  -> Bash uses chdir(2)
  -> same shell continues in new directory
```

The child never changes the parent.

Remaining:

- [ ] `make check`
- [ ] `NO_COLOR=1 make check`
- [ ] `git diff --check`
- [ ] reinstall + smoke test
- [ ] commit, push, PR, merge

Next: `wslx open <path>` / `wopen <path>`.
