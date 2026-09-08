# PathX — `wslx path`

PathX is the first real WSLX feature command.

It converts paths between Windows and WSL formats while keeping the command
interface consistent with the rest of WSLX.

## Command contract

Automatic direction detection:

```bash
wslx path 'D:\Programming\Test'
wslx path '/mnt/d/Programming/Test'
```

Explicit conversion:

```bash
wslx path --to-wsl 'D:\Programming\Test'
wslx path --to-windows '/mnt/d/Programming/Test'
```

Help:

```bash
wslx path --help
```

## Why PathX exists

WSL already provides the `wslpath` utility.

PathX uses `wslpath` as its conversion backend and adds the WSLX command
contract around it:

- automatic conversion-direction detection;
- explicit conversion modes;
- argument validation;
- consistent WSLX errors;
- integrated help;
- automated tests;
- future reuse by other WSLX commands.

## Automatic detection

A Windows drive path such as:

```text
D:\Programming\Test
```

is converted using:

```bash
wslpath -u
```

A WSL path such as:

```text
/mnt/d/Programming/Test
```

is converted using:

```bash
wslpath -w
```

If the input matches neither supported form, PathX returns an error instead of
guessing.

## Explicit modes

### `--to-wsl`

Forces Windows → WSL conversion.

```bash
wslx path --to-wsl 'D:\Programming\Test'
```

### `--to-windows`

Forces WSL → Windows conversion.

```bash
wslx path --to-windows '/mnt/d/Programming/Test'
```

## Paths containing spaces

Quote paths containing spaces:

```bash
wslx path 'D:\Programming Files\Test'
```

PathX keeps the path as one shell argument, so the spaces are preserved.

## Error behavior

### Missing path

```bash
wslx path
```

Returns exit code `2`.

### Unknown option

```bash
wslx path --bad-option test
```

Returns exit code `2`.

### Missing backend

If `wslpath` is unavailable, PathX reports that the conversion backend is
missing and returns a failure status.

## Implementation flow

```text
wslx path ...
    |
    v
bin/wslx
    |
    v
commands/path.sh
    |
    +--> parse options
    |
    +--> validate one path
    |
    +--> verify wslpath exists
    |
    +--> detect direction or use explicit mode
    |
    v
wslpath -u / -w
    |
    v
converted path
```

## Tests

`tests/test-path.sh` verifies:

- automatic Windows → WSL conversion;
- automatic WSL → Windows conversion;
- `--to-wsl`;
- `--to-windows`;
- paths containing spaces;
- missing path;
- invalid option;
- help output.

Installed-package coverage belongs in `tests/test-install.sh`.