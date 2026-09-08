# Command Modules

This directory contains one implementation module per WSLX feature.

Current module:

- `path.sh` — Windows/WSL path interoperability for WSLX-002.

The top-level executable in `bin/` loads command modules and dispatches to them;
feature behavior should not accumulate in the dispatcher.

Planned examples:

- `open.sh` — Windows file/folder opening.
- `clip.sh` — Windows clipboard integration.
- `run.sh` — Windows execution with deliberate path handling.
- `ports.sh` — port/process inspection.
- `kill-port.sh` — safe termination by listening port.
