#!/usr/bin/env bash

TESTS_PASSED=0
TESTS_FAILED=0

if [[ -t 1 && -z "${NO_COLOR:-}" && "${TERM:-}" != "dumb" ]]; then
    TEST_GREEN=$'\033[32m'
    TEST_RED=$'\033[31m'
    TEST_BOLD=$'\033[1m'
    TEST_RESET=$'\033[0m'
else
    TEST_GREEN=""
    TEST_RED=""
    TEST_BOLD=""
    TEST_RESET=""
fi

pass() {
    TESTS_PASSED=$((TESTS_PASSED + 1))
    printf '%s[PASS]%s %s\n' "$TEST_GREEN" "$TEST_RESET" "$1"
}

fail() {
    TESTS_FAILED=$((TESTS_FAILED + 1))
    printf '%s[FAIL]%s %s\n' "$TEST_RED" "$TEST_RESET" "$1" >&2
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
    printf '\n'

    if (( TESTS_FAILED == 0 )); then
        printf '%s%s%d passed, 0 failed%s\n' \
            "$TEST_GREEN" "$TEST_BOLD" "$TESTS_PASSED" "$TEST_RESET"
        return 0
    fi

    printf '%s%s%d passed, %d failed%s\n' \
        "$TEST_RED" "$TEST_BOLD" "$TESTS_PASSED" "$TESTS_FAILED" "$TEST_RESET"
    return 1
}
