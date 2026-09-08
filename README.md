# WSLX

WSLX is a small command-line toolkit for working between Windows and WSL.

Current feature: **PathX**, which converts paths between Windows and WSL formats.

## Install

Open WSL and run:

```bash
git clone https://github.com/DorManDel/wslx.git
cd wslx
./install.sh
source ~/.bashrc
```

Check the installation:

```bash
wslx version
wslx doctor
```

WSLX installs for the current user under `~/.local`. `sudo` is not required.

## Path conversion

Windows to WSL:

```bash
wslx path 'D:\Programming\Test'
```

```text
/mnt/d/Programming/Test
```

WSL to Windows:

```bash
wslx path '/mnt/d/Programming/Test'
```

```text
D:\Programming\Test
```

You can also choose the direction explicitly:

```bash
wslx path --to-wsl 'D:\Programming\Test'
wslx path --to-windows '/mnt/d/Programming/Test'
```

For command help:

```bash
wslx path --help
```

## Update

From your cloned repository:

```bash
git pull
./install.sh
source ~/.bashrc
```

## Uninstall

```bash
wslx uninstall
```

Then refresh the current shell:

```bash
source ~/.bashrc
```

## Development

Run the project checks with:

```bash
make check
```

Project documentation is under `docs/`.
