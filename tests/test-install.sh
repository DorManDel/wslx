#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=testlib.sh
source "$ROOT_DIR/tests/testlib.sh"

TEST_HOME="$(mktemp -d)"
trap 'rm -rf "$TEST_HOME"' EXIT

printf '# user content must survive\nexport USER_SETTING=keep-me\n' > "$TEST_HOME/.bashrc"

HOME="$TEST_HOME" WSLX_ALLOW_NON_WSL=1 "$ROOT_DIR/install.sh" --quiet

assert_file_exists "$TEST_HOME/.local/bin/wslx" "installer creates CLI entry point"
assert_file_exists "$TEST_HOME/.local/share/wslx/lib/core.sh" "installer copies shared libraries"

marker_count="$(grep -Fxc '# >>> WSLX managed block >>>' "$TEST_HOME/.bashrc")"
assert_eq "1" "$marker_count" "installer injects one managed Bash block"

# Reinstall to verify idempotence.
HOME="$TEST_HOME" WSLX_ALLOW_NON_WSL=1 "$ROOT_DIR/install.sh" --quiet
marker_count="$(grep -Fxc '# >>> WSLX managed block >>>' "$TEST_HOME/.bashrc")"
assert_eq "1" "$marker_count" "reinstall does not duplicate managed Bash block"

installed_version="$(HOME="$TEST_HOME" "$TEST_HOME/.local/bin/wslx" version)"
assert_eq "$(cat "$ROOT_DIR/VERSION")" "$installed_version" "installed CLI resolves installed data"

HOME="$TEST_HOME" "$TEST_HOME/.local/bin/wslx" uninstall --yes >/dev/null
assert_file_missing "$TEST_HOME/.local/bin/wslx" "uninstall removes CLI entry point"
assert_file_missing "$TEST_HOME/.local/share/wslx" "uninstall removes WSLX data directory"

if grep -q 'USER_SETTING=keep-me' "$TEST_HOME/.bashrc"; then
    pass "uninstall preserves unrelated .bashrc content"
else
    fail "uninstall preserves unrelated .bashrc content"
fi

if grep -Fq '# >>> WSLX managed block >>>' "$TEST_HOME/.bashrc"; then
    fail "uninstall removes managed Bash block"
else
    pass "uninstall removes managed Bash block"
fi

finish_tests
