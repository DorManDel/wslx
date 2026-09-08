#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=testlib.sh
source "$ROOT_DIR/tests/testlib.sh"

WSLX="$ROOT_DIR/bin/wslx"

if ! command -v wslpath >/dev/null 2>&1; then
    printf 'SKIP: wslpath is unavailable outside WSL\n'
    exit 0
fi

actual="$("$WSLX" path 'D:\Programming\Test')"
assert_eq "/mnt/d/Programming/Test" "$actual" \
    "path converts Windows input to WSL"

actual="$("$WSLX" path '/mnt/d/Programming/Test')"
assert_eq "/mnt/d/Programming/Test" "$actual" \
    "path keeps WSL input usable in WSL"

actual="$("$WSLX" 'D:\Programming\Test')"
assert_eq "/mnt/d/Programming/Test" "$actual" \
    "direct path shortcut converts Windows input"

actual="$("$WSLX" '/mnt/d/Programming/Test')"
assert_eq "/mnt/d/Programming/Test" "$actual" \
    "direct path shortcut keeps WSL input"

actual="$("$WSLX" path --wsl 'D:\Programming\Test')"
assert_eq "/mnt/d/Programming/Test" "$actual" \
    "explicit --wsl conversion"

actual="$("$WSLX" path --win '/mnt/d/Programming/Test')"
assert_eq 'D:\Programming\Test' "$actual" \
    "explicit --win conversion"

actual="$("$WSLX" --win '/mnt/d/Programming/Test')"
assert_eq 'D:\Programming\Test' "$actual" \
    "top-level --win shortcut"

actual="$("$WSLX" path --win 'D:\Programming\Test')"
assert_eq 'D:\Programming\Test' "$actual" \
    "--win keeps Windows input in Windows form"

# Captured output is not a TTY, so --link intentionally falls back to plain
# Windows text rather than leaking OSC-8 escape sequences into a pipe/script.
actual="$("$WSLX" --link '/mnt/d/Programming/Test')"
assert_eq 'D:\Programming\Test' "$actual" \
    "--link falls back to plain Windows path when not interactive"

actual="$("$WSLX" 'D:\Programming Files\Test')"
assert_eq "/mnt/d/Programming Files/Test" "$actual" \
    "paths containing spaces are preserved"

actual="$(cd "$ROOT_DIR" && "$WSLX" .)"
assert_eq "." "$actual" \
    "existing relative path shortcut is accepted"

if "$WSLX" path >/dev/null 2>&1; then
    fail "missing path returns exit code 2"
else
    status=$?
    assert_eq "2" "$status" "missing path returns exit code 2"
fi

if "$WSLX" path --bad-option test >/dev/null 2>&1; then
    fail "invalid option returns exit code 2"
else
    status=$?
    assert_eq "2" "$status" "invalid option returns exit code 2"
fi

help_output="$("$WSLX" path --help)"
if [[ "$help_output" == *"--win"* && "$help_output" == *"--link"* ]]; then
    pass "path help renders current options"
else
    fail "path help renders current options"
fi

finish_tests
