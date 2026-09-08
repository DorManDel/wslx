<p align="center">
  <img src="assets/wslx-logo.svg" width="120" alt="WSLX logo">
</p>

<h1 align="center">WSLX</h1>

<p align="center">
  Small command-line tools for moving cleanly between Windows and WSL.
</p>

<p align="center">
  <img alt="WSL" src="https://img.shields.io/badge/WSL-supported-7c2da8">
  <img alt="Bash" src="https://img.shields.io/badge/shell-Bash-d946ef">
  <img alt="license" src="https://img.shields.io/badge/license-MIT-6b21a8">
</p>

WSLX removes small Windows/WSL workflow annoyances: pasted Windows paths,
Windows path output, environment checks, and later navigation/open/clipboard
commands under one consistent CLI.

## Commands

| Command | What it does | Example | Details |
|---|---|---|---|
| `wslx <path>` | Return a path usable in WSL. Windows input is converted; WSL input stays unchanged. | `wslx 'D:\Projects\Demo'` | [Path](docs/commands/path.md) |
| `wslx path <path>` | Explicit/readable form of the same path operation. | `wslx path '/mnt/d/Projects/Demo'` | [Path](docs/commands/path.md) |
| `wslx --win <path>` | Return the Windows representation. | `wslx --win '/mnt/d/Projects/Demo'` | [Path](docs/commands/path.md) |
| `wslx --link <path>` | Show the Windows path as a clickable terminal link when supported. | `wslx --link ./README.md` | [Path](docs/commands/path.md) |
| `wslx doctor` | Check that WSLX and its WSL environment are healthy. | `wslx doctor` | [CLI reference](docs/COMMANDS.md) |
| `wslx version` | Print the installed version. | `wslx version` | [CLI reference](docs/COMMANDS.md) |
| `wslx uninstall` | Remove the current-user installation. | `wslx uninstall` | [CLI reference](docs/COMMANDS.md) |

### Quick examples

```bash
# Windows path -> WSL path
wslx 'D:\Programming\Test'
# /mnt/d/Programming/Test

# Already usable in WSL -> unchanged
wslx '/mnt/d/Programming/Test'
# /mnt/d/Programming/Test

# Ask for Windows form
wslx --win '/mnt/d/Programming/Test'
# D:\Programming\Test

# Interactive Windows link
wslx --link ./README.md
```

<details>
<summary><strong>Install WSLX</strong></summary>

Open WSL and run:

```bash
git clone https://github.com/DorManDel/wslx.git
cd wslx
./install.sh
source ~/.bashrc
```

Verify it:

```bash
wslx version
wslx doctor
```

WSLX installs under `~/.local`; `sudo` is not required.

</details>

<details>
<summary><strong>Update WSLX</strong></summary>

From the cloned repository:

```bash
git pull
./install.sh
source ~/.bashrc
hash -r
```

Then verify:

```bash
wslx doctor
```

</details>

<details>
<summary><strong>Uninstall WSLX</strong></summary>

```bash
wslx uninstall
source ~/.bashrc
hash -r
```

</details>

## Health check

```bash
command -v wslx
wslx version
wslx doctor
```

A healthy installation should resolve `wslx`, print its version, and finish the
doctor checks successfully.

## Command design

The public CLI grammar and naming rules live in [docs/COMMANDS.md](docs/COMMANDS.md).
Planned commands are tracked in [docs/ROADMAP.md](docs/ROADMAP.md).

## Development

Run the full pre-commit gate:

```bash
make check
```

The test runner uses color in an interactive terminal and ends with a suite
summary. Set `NO_COLOR=1` when plain output is preferred.
