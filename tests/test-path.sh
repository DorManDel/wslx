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
    "automatic Windows -> WSL conversion"

actual="$("$WSLX" path '/mnt/d/Programming/Test')"
assert_eq 'D:\Programming\Test' "$actual" \
    "automatic WSL -> Windows conversion"

actual="$("$WSLX" path --to-wsl 'D:\Programming\Test')"
assert_eq "/mnt/d/Programming/Test" "$actual" \
    "explicit --to-wsl conversion"

actual="$("$WSLX" path --to-windows '/mnt/d/Programming/Test')"
assert_eq 'D:\Programming\Test' "$actual" \
    "explicit --to-windows conversion"

actual="$("$WSLX" path 'D:\Programming Files\Test')"
assert_eq "/mnt/d/Programming Files/Test" "$actual" \
    "paths containing spaces are preserved"

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
if [[ "$help_output" == *"wslx path"* ]]; then
    pass "path help renders"
else
    fail "path help renders"
fi

finish_tests