#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=testlib.sh
source "$ROOT_DIR/tests/testlib.sh"

map_file="$ROOT_DIR/docs/MAP.md"

# Change records are timestamped instances of one documented sector and are
# intentionally excluded from exact per-file indexing.
#
# Use Git's view of the repository so tracked files and new non-ignored files
# are validated, while personal/local files covered by .gitignore are skipped.
while IFS= read -r relative; do
    case "$relative" in
        docs/changes/*) continue ;;
    esac

    if grep -Fq "\`$relative\`" "$map_file"; then
        pass "map indexes $relative"
    else
        fail "map indexes $relative"
    fi
done < <(
    cd "$ROOT_DIR"
    git ls-files --cached --others --exclude-standard | sort
)

finish_tests
