#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=testlib.sh
source "$ROOT_DIR/tests/testlib.sh"

export PATH="$ROOT_DIR/bin:$PATH"

# shellcheck source=../shell/bash/wslx.bash
source "$ROOT_DIR/shell/bash/wslx.bash"

ORIGINAL_DIR="$PWD"
TEST_DIR="$(mktemp -d)"
trap 'builtin cd -- "$ORIGINAL_DIR"; rm -rf "$TEST_DIR"' EXIT

mkdir -p "$TEST_DIR/target"
mkdir -p "$TEST_DIR/folder with spaces"
mkdir -p "$TEST_DIR/relative"
printf 'not a directory\n' > "$TEST_DIR/file.txt"

wcd "$TEST_DIR/target"
assert_eq "$TEST_DIR/target" "$PWD" "wcd changes the current Bash directory"
builtin cd -- "$ORIGINAL_DIR"

wslx cd "$TEST_DIR/target"
assert_eq "$TEST_DIR/target" "$PWD" "wslx cd changes the current Bash directory"
builtin cd -- "$ORIGINAL_DIR"

wcd "$TEST_DIR/folder with spaces"
assert_eq "$TEST_DIR/folder with spaces" "$PWD" "cd preserves paths containing spaces"
builtin cd -- "$ORIGINAL_DIR"

builtin cd -- "$TEST_DIR"
wcd relative
assert_eq "$TEST_DIR/relative" "$PWD" "cd accepts relative paths"
builtin cd -- "$ORIGINAL_DIR"

if command -v wslpath >/dev/null 2>&1 && [[ "$ROOT_DIR" =~ ^/mnt/[A-Za-z]/ ]]; then
    windows_root="$(wslpath -w "$ROOT_DIR")"
    wcd "$windows_root"
    assert_eq "$ROOT_DIR" "$PWD" "wcd accepts a Windows drive path"
    builtin cd -- "$ORIGINAL_DIR"
fi

version_output="$(wslx version)"
assert_eq "$(cat "$ROOT_DIR/VERSION")" "$version_output" \
    "wslx wrapper delegates normal commands without recursion"

help_output="$(wslx cd --help)"
if [[ "$help_output" == *"wslx cd <path>"* && "$help_output" == *"wcd <path>"* ]]; then
    pass "cd help shows canonical and shortcut forms"
else
    fail "cd help shows canonical and shortcut forms"
fi

if wcd "$TEST_DIR/missing" >/dev/null 2>&1; then
    fail "missing directory returns exit code 1"
else
    status=$?
    assert_eq "1" "$status" "missing directory returns exit code 1"
fi

if wcd "$TEST_DIR/file.txt" >/dev/null 2>&1; then
    fail "file operand returns exit code 1"
else
    status=$?
    assert_eq "1" "$status" "file operand returns exit code 1"
fi

if wcd >/dev/null 2>&1; then
    fail "missing operand returns exit code 2"
else
    status=$?
    assert_eq "2" "$status" "missing operand returns exit code 2"
fi

if wcd "$TEST_DIR/target" "$TEST_DIR/relative" >/dev/null 2>&1; then
    fail "multiple operands return exit code 2"
else
    status=$?
    assert_eq "2" "$status" "multiple operands return exit code 2"
fi

if "$ROOT_DIR/bin/wslx" cd "$TEST_DIR/target" >/dev/null 2>"$TEST_DIR/direct-error"; then
    fail "direct child CLI refuses to pretend it can change the parent shell"
else
    status=$?
    assert_eq "1" "$status" "direct child cd returns operational error"
    if grep -q "Bash integration" "$TEST_DIR/direct-error"; then
        pass "direct child cd explains the parent-shell requirement"
    else
        fail "direct child cd explains the parent-shell requirement"
    fi
fi

finish_tests
