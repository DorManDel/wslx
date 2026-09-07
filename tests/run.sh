#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
status=0

printf 'WSLX automated tests\n\n'

for test_file in "$ROOT_DIR"/tests/test-*.sh; do
    printf '==> %s\n' "$(basename -- "$test_file")"
    if bash "$test_file"; then
        printf '\n'
    else
        status=1
        printf '\n'
    fi
done

exit "$status"
