# Command Modules

This sector will contain one implementation module per WSLX feature.

Foundation 001 deliberately contains no feature module yet. The first module
will be `path.sh` in **WSLX-002 — PathX**. Keeping the directory now documents
the intended architecture without prematurely mixing feature logic into
`bin/wslx`.

Planned examples:

- `path.sh` — Windows ↔ WSL path conversion.
- `open.sh` — Windows Explorer integration.
- `clip.sh` — Windows clipboard output.
- `ports.sh` — port/process inspection.
- `killport.sh` — safe termination by listening port.
