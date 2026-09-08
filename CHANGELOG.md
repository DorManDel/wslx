# Changelog

All notable WSLX changes are recorded here at release-summary level. Detailed,
timestamped engineering records live in `docs/changes/`.

## [Unreleased]


### Added — WSLX-003 CD / WCD

- `wslx cd <path>` changes the current Bash directory from Windows, WSL, or relative input.
- `wcd <path>` provides the fast navigation form.
- Parent-shell integration reuses Path Interop.
- Direct child execution refuses to fake a persistent `cd`.
- Dedicated current-shell and installed-integration tests.
- Parent/child/`chdir(2)` behavior documented simply.


### Added — WSLX-002 Path Interop

- Windows paths normalize to WSL form by default.
- `wslx <path>` direct shortcut and explicit `wslx path <path>` form.
- Human-readable `--wsl`, `--win`, and `--link` options.
- Interactive Windows-path hyperlinks with plain output for pipes/capture.
- CLI naming/alias contract in `docs/COMMANDS.md`.
- Standard command-design contract template for future features.
- Professional README command reference and WSLX SVG mark.
- Colored test output, suite summary, failure exit codes, and rerun hints.

### Added — WSLX-001

- Project/repository foundation.
- Living Mapxplanation and roadmap.
- CLI help/version/doctor foundation.
- Per-user idempotent installer and safe uninstaller.
- Managed Bash shell integration and Bash completion foundation.
- Dependency-free test runner and installer/uninstaller tests.
- Makefile workflow shortcuts.
- Timestamped change-record generator.
- Basic man page.
