# foundation-portability-lint

Timestamp: 2026-09-08T00:26:42+03:00
Version: 0.1.0-dev

## Goal

Validate and harden the WSLX Foundation on a real Windows + WSL development
environment before publishing the baseline to GitHub.

## Mapxplanation Update

Updated `docs/MAP.md` to:

- document `.gitattributes`;
- include Git portability policy in the repository-root responsibility;
- explain that `tests/test-map.sh` validates Git-relevant files while respecting
  `.gitignore`.

## Files Changed

- `.gitattributes`
- `.gitignore`
- `Makefile`
- `bin/wslx`
- `docs/CURRENT_STATE.md`
- `docs/DEVELOPMENT.md`
- `docs/MAP.md`
- `install.sh`
- `lib/ui.sh`
- `scripts/new-change.sh`
- `tests/test-foundation.sh`
- `tests/test-map.sh`
- `tests/testlib.sh`

## Why

- Windows-mounted NTFS exposed permission-only Git changes.
- WSLX needed an explicit LF line-ending policy for Windows ↔ WSL development.
- ShellCheck found ambiguous shell control flow and quoting issues.
- Dynamic sourced libraries needed proper ShellCheck source resolution.
- Markdown backticks inside the change-record heredoc needed escaping.
- The installer needed clearer handling of the literal `$PATH` written to
  `.bashrc`.
- Personal VS Code workspace state should remain outside Git and outside the
  Mapxplanation.
- The map test needed to respect `.gitignore`.
- Timestamped change-record filenames need to remain Windows-safe.

## Validation

- [x] `make test`
- [x] `make lint`
- [x] `make check`
- [x] `./bin/wslx doctor`

## Result

- Foundation tests pass.
- Installer tests pass.
- Map tests pass: 28 passed, 0 failed.
- ShellCheck passes with exit code 0.
- `wslx doctor` passes inside WSL.
- Git ignores the personal VS Code workspace.
- Repository portability behavior is documented.

## Next

Publish the validated Foundation baseline to GitHub and verify the clean:

clone -> test -> install -> doctor -> uninstall

lifecycle before beginning WSLX-002 PathX.