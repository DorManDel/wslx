#!/usr/bin/env bash

TESTS_PASSED=0
TESTS_FAILED=0

pass() {
    TESTS_PASSED=$((TESTS_PASSED + 1))
    printf '[PASS] %s\n' "$1"
}

fail() {
    TESTS_FAILED=$((TESTS_FAILED + 1))
    printf '[FAIL] %s\n' "$1" >&2
}

assert_eq() {
    local expected="$1"
    local actual="$2"
    local description="$3"

    if [[ "$expected" == "$actual" ]]; then
        pass "$description"
    else
        fail "$description (expected='$expected', actual='$actual')"
    fi
}

assert_file_exists() {
    local path="$1"
    local description="$2"
    [[ -f "$path" ]] && pass "$description" || fail "$description (missing: $path)"
}

assert_file_missing() {
    local path="$1"
    local description="$2"
    [[ ! -e "$path" ]] && pass "$description" || fail "$description (still exists: $path)"
}

finish_tests() {
    printf '\n%d passed, %d failed\n' "$TESTS_PASSED" "$TESTS_FAILED"
    (( TESTS_FAILED == 0 ))
}
