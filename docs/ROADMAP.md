# WSLX Command Roadmap

This is the idea catalog, not a promise that every command belongs in the first
release. We add commands only when they solve a repeated WSL/Windows workflow.

## Core interoperability

| Command | Short description | Elaborated behavior |
|---|---|---|
| `pathx` / `wslx path` | Convert a path. | Detect Windows vs WSL syntax, delegate conversion to `wslpath`, support explicit direction flags, spaces, clipboard output and clear errors. |
| `wopen` / `wslx open` | Open from Windows. | Accept a WSL or Windows path, normalize it, then open the file/folder using the appropriate Windows shell/Explorer behavior. |
| `wclip` / `wslx clip` | Copy to Windows clipboard. | Accept text arguments or stdin and send the exact result to the native Windows clipboard without contaminating piped output with status text. |
| `wpaste` / `wslx paste` | Read Windows clipboard. | Fetch clipboard text into WSL so it can be printed, piped to another command, or optionally saved to a file. |
| `wrun` / `wslx run` | Run a Windows program. | Launch `.exe`/Windows commands from WSL and safely pre-convert arguments known to be paths before execution. |
| `wcd` | `cd` to a Windows path. | Shell-only function that converts `D:\\...` to `/mnt/d/...` and changes the *current Bash process* directory; implemented in shell integration, not as a child executable. |
| `wcode` | Open project in VS Code. | Normalize the project path and invoke the preferred VS Code/WSL bridge consistently from either path format. |

## Diagnostics and process helpers

| Command | Short description | Elaborated behavior |
|---|---|---|
| `doctor` | Diagnose WSLX. | Verify WSL environment, expected Windows bridge executables, installation layout, PATH, shell integration and optional productivity dependencies. |
| `winfo` | Show WSL environment. | Summarize distro, kernel, WSL version signals, Windows interop state, mount information and key executable locations. |
| `drives` | Show Windows drives/mounts. | Display mounted Windows drives and their WSL mount points in a concise table. |
| `ports` | Show useful listening ports. | Present port, PID, process and address information in a developer-friendly view instead of making the user combine `ss`, `lsof`, and `ps`. |
| `killport` | Stop the owner of a port. | Resolve a port to a process, display what will be terminated, default to `SIGTERM`, ask for confirmation, and reserve force-kill for an explicit flag. |

## Smart shell / navigation experiments

| Command | Short description | Elaborated behavior |
|---|---|---|
| `wslx exec` | Execute with safe path resolution. | Inspect declared/path-like arguments, convert invalid Windows paths *before* running the target command, and never blindly retry side-effecting commands after failure. |
| `jump` | Interactive project jump. | Use `zoxide` history when available and optionally `fzf` for fuzzy interactive selection; this is integration, not a reimplementation of those mature tools. |
| `pick` | Interactive file/dir picker. | Combine `fd`/`find` with `fzf`, returning a selected path that can feed `cd`, `wopen`, editors, or scripts. |
| smart `cd` mode | Transparently accept Windows paths. | Optional opt-in Bash integration that detects a Windows-looking argument and converts it before invoking the real `cd`; disabled by default until thoroughly tested. |

## Package lifecycle

| Command | Short description | Elaborated behavior |
|---|---|---|
| `wslx install` | Install/update local package. | Future self-bootstrap/update layer around the safe installer; initial install still starts from a cloned/downloaded repository. |
| `wslx uninstall` | Remove WSLX. | Already present in Foundation 001; removes only WSLX-owned files and the marked shell block. |
| `wslx update` | Update WSLX. | Fetch a signed/tagged release or Git checkout update, validate it, run tests/migrations if needed, then replace the local install. |
| `wslx config` | Manage options. | Expose user preferences such as colors, smart-path opt-in, aliases and integrations without requiring hand-edits to `.bashrc`. |

## Existing tools that inspire integrations

- **zoxide** — learns frequently/recently visited directories and makes jumping
  to them much shorter than typing full paths.
- **fzf** — fuzzy interactive selector: type a few letters and narrow a large
  list live inside the terminal.
- **ripgrep (`rg`)** — very fast recursive text/code search.
- **fd** — simpler, developer-friendly file search.
- **bat** — `cat`-style output with syntax highlighting and useful paging.
- **eza** — modern directory listing.
- **tldr** — concise usage examples for commands.
- **jq** — command-line JSON processing.
- **direnv** — automatically loads project-specific environment settings.
- **atuin** — searchable, richer shell history.

WSLX should integrate with good existing tools where that gives more value than
rebuilding them.
