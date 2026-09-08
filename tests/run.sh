#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -t 1 && -z "${NO_COLOR:-}" && "${TERM:-}" != "dumb" ]]; then
    GREEN=$'\033[32m'
    RED=$'\033[31m'
    CYAN=$'\033[36m'
    BOLD=$'\033[1m'
    RESET=$'\033[0m'
else
    GREEN=""
    RED=""
    CYAN=""
    BOLD=""
    RESET=""
fi

status=0
suite_passed=0
suite_failed=0
declare -a suite_names=()
declare -a suite_codes=()

printf '%s%sWSLX automated tests%s\n\n' "$BOLD" "$CYAN" "$RESET"

for test_file in "$ROOT_DIR"/tests/test-*.sh; do
    test_name="$(basename -- "$test_file")"
    printf '%s==> %s%s\n' "$BOLD" "$test_name" "$RESET"

    if bash "$test_file"; then
        rc=0
        suite_passed=$((suite_passed + 1))
    else
        rc=$?
        suite_failed=$((suite_failed + 1))
        status=1
    fi

    suite_names+=("$test_name")
    suite_codes+=("$rc")
    printf '\n'
done

printf '%s%sWSLX TEST SUMMARY%s\n' "$BOLD" "$CYAN" "$RESET"
printf '%s\n' '----------------------------------------'

for index in "${!suite_names[@]}"; do
    test_name="${suite_names[$index]}"
    rc="${suite_codes[$index]}"

    if (( rc == 0 )); then
        printf '%s[PASS]%s %-24s exit=0\n' "$GREEN" "$RESET" "$test_name"
    else
        printf '%s[FAIL]%s %-24s exit=%d\n' "$RED" "$RESET" "$test_name" "$rc"
        printf '       rerun: ./tests/%s\n' "$test_name"
    fi
done

printf '\nSuites: %d passed, %d failed\n' "$suite_passed" "$suite_failed"

if (( status == 0 )); then
    printf '%s%sResult: PASS%s\n' "$GREEN" "$BOLD" "$RESET"
else
    printf '%s%sResult: FAIL%s (exit=1)\n' "$RED" "$BOLD" "$RESET"
fi

exit "$status"
