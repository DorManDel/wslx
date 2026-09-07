#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=testlib.sh
source "$ROOT_DIR/tests/testlib.sh"

expected_version="$(cat "$ROOT_DIR/VERSION")"
actual_version="$($ROOT_DIR/bin/wslx version)"
assert_eq "$expected_version" "$actual_version" "wslx version reads VERSION"

if "$ROOT_DIR/bin/wslx" help | grep -q 'WSLX'; then
    pass "wslx help renders"
else
    fail "wslx help renders"
fi

set +e
"$ROOT_DIR/bin/wslx" definitely-not-a-command >/dev/null 2>&1
status=$?
set -e
assert_eq "2" "$status" "unknown command returns exit code 2"

finish_tests
