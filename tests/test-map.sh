#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=testlib.sh
source "$ROOT_DIR/tests/testlib.sh"

map_file="$ROOT_DIR/docs/MAP.md"

# Change records are timestamped instances of one documented sector and are
# intentionally excluded from exact per-file indexing. Everything else must be
# named in the living Mapxplanation.
while IFS= read -r path; do
    relative="${path#./}"
    case "$relative" in
        .git/*|docs/changes/*) continue ;;
    esac

    if grep -Fq "\`$relative\`" "$map_file"; then
        pass "map indexes $relative"
    else
        fail "map indexes $relative"
    fi
done < <(cd "$ROOT_DIR" && find . -type f | sort)

finish_tests
