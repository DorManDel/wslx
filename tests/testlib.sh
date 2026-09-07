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

    # Use an explicit branch instead of "A && B || C".
    # The latter is not a true if/else expression because C can also run
    # when B itself returns a failure status.
    if [[ -f "$path" ]]; then
        pass "$description"
    else
        fail "$description (missing: $path)"
    fi
}

assert_file_missing() {
    local path="$1"
    local description="$2"

    if [[ ! -e "$path" ]]; then
        pass "$description"
    else
        fail "$description (still exists: $path)"
    fi
}

finish_tests() {
    printf '\n%d passed, %d failed\n' "$TESTS_PASSED" "$TESTS_FAILED"
    (( TESTS_FAILED == 0 ))
}
