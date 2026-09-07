#!/usr/bin/env bash
# WSLX per-user uninstaller.
#
# It removes only WSLX-owned files and the explicitly marked Bash block.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${WSLX_PREFIX:-}"
ASSUME_YES=0

START_MARKER='# >>> WSLX managed block >>>'
END_MARKER='# <<< WSLX managed block <<<'

usage() {
    cat <<'EOF_USAGE'
Usage: uninstall.sh [options]

Options:
  --prefix PATH   Remove an installation under PATH
  --yes           Do not ask for confirmation
  -h, --help      Show this help

Installed users can simply run:
  wslx uninstall
EOF_USAGE
}

while (( $# > 0 )); do
    case "$1" in
        --prefix)
            [[ $# -ge 2 ]] || { printf 'uninstall.sh: --prefix requires a path\n' >&2; exit 2; }
            PREFIX="$2"
            shift 2
            ;;
        --yes|-y)
            ASSUME_YES=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            printf 'uninstall.sh: unknown option: %s\n' "$1" >&2
            exit 2
            ;;
    esac
done

# If this is the installed copy at <prefix>/share/wslx/uninstall.sh, derive the
# prefix from the script location. Otherwise default to ~/.local.
if [[ -z "$PREFIX" ]]; then
    if [[ "$(basename -- "$SCRIPT_DIR")" == "wslx" && "$(basename -- "$(dirname -- "$SCRIPT_DIR")")" == "share" ]]; then
        PREFIX="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
    else
        PREFIX="$HOME/.local"
    fi
fi

BIN_DIR="$PREFIX/bin"
DATA_DIR="$PREFIX/share/wslx"
MAN_FILE="$PREFIX/share/man/man1/wslx.1"
BASHRC="${WSLX_BASHRC:-$HOME/.bashrc}"

if (( ASSUME_YES == 0 )); then
    printf 'Remove WSLX from %s? [y/N] ' "$PREFIX"
    read -r answer
    case "$answer" in
        y|Y|yes|YES) ;;
        *) printf 'Cancelled.\n'; exit 0 ;;
    esac
fi

strip_managed_block() {
    local file="$1"
    local temporary
    temporary="$(mktemp)"

    awk -v start="$START_MARKER" -v end="$END_MARKER" '
        $0 == start { inside = 1; next }
        $0 == end   { inside = 0; next }
        !inside     { print }
    ' "$file" > "$temporary"

    mv "$temporary" "$file"
}

if [[ -f "$BASHRC" ]]; then
    start_count="$(grep -Fxc "$START_MARKER" "$BASHRC" || true)"
    end_count="$(grep -Fxc "$END_MARKER" "$BASHRC" || true)"

    if [[ "$start_count" == "$end_count" && "$start_count" -gt 0 ]]; then
        strip_managed_block "$BASHRC"
    elif [[ "$start_count" != "$end_count" ]]; then
        printf '⚠ malformed WSLX managed block in %s; leaving .bashrc unchanged.\n' "$BASHRC" >&2
    fi
fi

rm -f "$BIN_DIR/wslx" "$MAN_FILE"
rm -rf "$DATA_DIR"

printf '✓ WSLX removed from %s\n' "$PREFIX"
printf '→ open a new shell (or source ~/.bashrc) to refresh the current session.\n'
