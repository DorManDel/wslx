# WSLX

WSLX is a Windows ↔ WSL productivity toolkit designed as a real installable CLI
package rather than a collection of copied `.bashrc` snippets.

**Current status:** `WSLX-001` foundation complete. Real interoperability
commands begin with PathX in `WSLX-002`.

## Foundation commands

```bash
./bin/wslx help
./bin/wslx version
./bin/wslx doctor
```

## Validate the repository

```bash
make check
```

The tests have no required third-party test framework. If ShellCheck is
installed, `make lint` uses it automatically.

## Install inside WSL

```bash
./install.sh
source ~/.bashrc
wslx doctor
```

The default install is per-user under `~/.local`; no `sudo` is required.
Re-running the installer is supported and does not duplicate the managed Bash
block.

## Uninstall

From anywhere after installation:

```bash
wslx uninstall
```

or from a source checkout:

```bash
./uninstall.sh
```

## GitHub-ready install flow

Once the repository is published as `DorManDel/wslx`, another computer can use:

```bash
git clone https://github.com/DorManDel/wslx.git && cd wslx && ./install.sh
```

A direct bootstrap one-liner can be added later after release/version integrity
checks exist; the clone-first method is intentionally easier to inspect.

## Living documentation

- `docs/MAP.md` — canonical architecture/file "Mapxplanation".
- `docs/ROADMAP.md` — command ideas with short and detailed descriptions.
- `docs/CURRENT_STATE.md` — where development currently stands.
- `docs/DEVELOPMENT.md` — required update/test/commit workflow.
- `docs/changes/` — timestamped records of meaningful changes.

See `make help` for the common development shortcuts.
