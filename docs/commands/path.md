# Path Interop — `wslx path`

The path command answers a simple default question:

> What path should I use here, in WSL?

Windows paths are converted to WSL form. Paths already usable in WSL are left
unchanged.

## User interface

Fast form:

```bash
wslx <path>
```

Explicit form:

```bash
wslx path <path>
```

Direction/presentation options:

```bash
wslx --wsl <path>
wslx --win <path>
wslx --link <path>
```

The same options also work after `path`:

```bash
wslx path --win <path>
```

## Default semantics

### Windows input

```bash
wslx 'D:\Programming\Test'
```

Output:

```text
/mnt/d/Programming/Test
```

### WSL input

```bash
wslx '/mnt/d/Programming/Test'
```

Output:

```text
/mnt/d/Programming/Test
```

The command does not automatically flip an already-usable WSL path to Windows.

## Explicit Windows form

```bash
wslx --win '/mnt/d/Programming/Test'
```

Output:

```text
D:\Programming\Test
```

If the input is already a Windows drive path, `--win` leaves it in Windows
form.

## Explicit WSL form

```bash
wslx --wsl 'D:\Programming\Test'
```

Output:

```text
/mnt/d/Programming/Test
```

`--wsl` documents intent but is equivalent to the default path mode.

## Clickable link

```bash
wslx --link '/mnt/d/Programming/Test'
```

In an interactive terminal, WSLX converts the path to Windows form and emits an
OSC-8 `file://` hyperlink whose visible label is the Windows path.

When stdout is redirected, piped, or captured, WSLX prints only the plain
Windows path. That keeps scripts and command substitution free of terminal
escape sequences.

## Backend

Actual Windows/WSL conversion is delegated to WSL's native `wslpath` utility.

WSLX adds:

- default normalize-for-WSL semantics;
- direct path shorthand;
- human-readable explicit modes;
- hyperlink presentation;
- consistent errors/help;
- tests and installed-package coverage.

## Dispatch flow

```text
wslx <path>
      |
      v
bin/wslx detects a path operand
      |
      v
commands/path.sh
      |
      +--> Windows input? -> wslpath -u
      |
      `--> WSL input?     -> return unchanged
```

Explicit Windows form:

```text
wslx --win <path>
      |
      v
commands/path.sh
      |
      +--> already Windows? -> return unchanged
      |
      `--> WSL/Linux input? -> wslpath -w
```

## Path-like top-level operands

The top-level shortcut is used when the first argument clearly looks like a
path, including:

- Windows drive paths such as `D:\...`;
- absolute WSL paths such as `/mnt/d/...`;
- `.`, `..`, `./...`, and `../...`;
- an existing relative file/directory.

Unknown non-path words remain unknown commands instead of being silently treated
as paths.

## Errors

### Missing path

```bash
wslx path
```

Exit code: `2`.

### Unknown path option

```bash
wslx path --bad-option value
```

Exit code: `2`.

### Missing conversion backend

When conversion is required and `wslpath` is unavailable, the command reports
the missing backend and returns a failure status.

## Tests

`tests/test-path.sh` verifies:

- Windows -> WSL default conversion;
- WSL input remains WSL;
- direct `wslx <path>` shortcut;
- `--wsl`;
- `--win`;
- top-level `--win`;
- `--link` plain-output fallback when captured;
- paths containing spaces;
- relative path shortcut;
- input/option errors;
- current help output.

`tests/test-install.sh` verifies the same core semantics from an installed copy.

## Planned integrations

Path conversion stays separate from actions. Future commands consume the path
behavior instead of adding unrelated side effects here:

```text
wslx cd <path>    / wcd    -> navigate current shell
wslx open <path>  / wopen  -> open in Windows
wslx run ...      / wrun   -> execute with deliberate path handling
```
