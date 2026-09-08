# WSLX Command Roadmap

This is the feature catalog. Command names follow `docs/COMMANDS.md` so new
features extend one consistent CLI instead of inventing their own naming style.

## Core interoperability

| Command | Alias | Status | Purpose |
|---|---|---|---|
| `wslx path <path>` | `wslx <path>` | Current | Make a path usable in WSL; use `--win` for Windows form and `--link` for an interactive Windows hyperlink. |
| `wslx cd <path>` | `wcd <path>` | Current | Normalize a Windows/WSL/relative path and change the current Bash directory through shell integration. |
| `wslx open <path>` | `wopen <path>` | Next | Open a file or folder through Windows/Explorer behavior. |
| `wslx clip` | `wclip` | Planned | Copy arguments or stdin to the Windows clipboard. |
| `wslx paste` | `wpaste` | Planned | Read Windows clipboard text into WSL. |
| `wslx code <path>` | `wcode <path>` | Planned | Open a project or file in VS Code using the correct WSL/Windows path context. |
| `wslx run <program> [args...]` | `wrun` | Planned | Run Windows programs from WSL and convert only declared/path-like arguments before execution. |

## Diagnostics

| Command | Purpose |
|---|---|
| `wslx doctor` | Verify WSL, installation layout, shell integration, PATH, and required bridges. |
| `wslx info` | Summarize distro, kernel, WSL version, interop state, mounts, and useful executable locations. |
| `wslx drives` | Show mounted Windows drives and their WSL mount points. |
| `wslx ports` | Show listening ports with PID/process information. |
| `wslx kill-port <port>` | Resolve a port to a process, show the target, confirm, then terminate safely. |

## Navigation experiments

| Command | Purpose |
|---|---|
| `wslx jump` | Jump to known projects/directories; integrate with `zoxide` and optionally `fzf` when available. |
| `wslx pick` | Interactively select a file/directory using existing tools such as `fd`/`find` + `fzf`. |
| smart `cd` mode | Optional Bash mode where the normal `cd` can accept Windows paths; keep disabled by default until well tested. |

## Package lifecycle

| Command | Purpose |
|---|---|
| `wslx install` | Future self-bootstrap layer around the repository installer. |
| `wslx update` | Update from a validated release or Git checkout. |
| `wslx uninstall` | Remove WSLX-owned files and its managed shell block. |
| `wslx config` | Manage preferences such as colors, aliases, smart-path behavior, and integrations. |

## Existing tools to integrate instead of rebuilding

- `wslpath` — native Windows/WSL path conversion backend.
- `explorer.exe` — Windows Explorer bridge available from WSL.
- `clip.exe` — Windows clipboard output.
- `zoxide` — learned/frequent directory jumping.
- `fzf` — fuzzy interactive selection.
- `fd` / `find` — file discovery.
- `ripgrep (rg)` — fast recursive text search.
- `jq` — command-line JSON processing.

WSLX should wrap mature tools when the wrapper removes Windows/WSL friction;
it should not reimplement them without a reason.
