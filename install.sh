#!/usr/bin/env bash
# WSLX per-user installer.
#
# Default layout:
#   ~/.local/bin/wslx
#   ~/.local/share/wslx/...
#
# The installer is idempotent: rerunning it replaces WSLX files and rewrites a
# single managed Bash block instead of duplicating configuration.

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${WSLX_PREFIX:-$HOME/.local}"
ENABLE_SHELL=1
QUIET=0

START_MARKER='# >>> WSLX managed block >>>'
END_MARKER='# <<< WSLX managed block <<<'

usage() {
    cat <<'EOF_USAGE'
Usage: ./install.sh [options]

Options:
  --prefix PATH   Install under PATH instead of ~/.local
  --no-shell      Do not modify ~/.bashrc
  --quiet         Reduce installer output
  -h, --help      Show this help

Testing only:
  WSLX_ALLOW_NON_WSL=1   allow installation outside WSL
EOF_USAGE
}

while (( $# > 0 )); do
    case "$1" in
        --prefix)
            [[ $# -ge 2 ]] || { printf 'install.sh: --prefix requires a path\n' >&2; exit 2; }
            PREFIX="$2"
            shift 2
            ;;
        --no-shell)
            ENABLE_SHELL=0
            shift
            ;;
        --quiet)
            QUIET=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            printf 'install.sh: unknown option: %s\n' "$1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

is_wsl() {
    grep -qiE '(microsoft|wsl)' /proc/sys/kernel/osrelease 2>/dev/null ||
        grep -qi 'microsoft' /proc/version 2>/dev/null
}

say() {
    (( QUIET == 1 )) || printf '%s\n' "$*"
}

if ! is_wsl && [[ "${WSLX_ALLOW_NON_WSL:-0}" != "1" ]]; then
    printf 'WSLX installer: this installer is intended to run inside WSL.\n' >&2
    printf 'For CI/tests only, set WSLX_ALLOW_NON_WSL=1.\n' >&2
    exit 1
fi

BIN_DIR="$PREFIX/bin"
DATA_DIR="$PREFIX/share/wslx"
MAN_DIR="$PREFIX/share/man/man1"
BASHRC="${WSLX_BASHRC:-$HOME/.bashrc}"

say "WSLX Installer"
say "→ prefix: $PREFIX"

mkdir -p "$BIN_DIR" "$DATA_DIR" "$MAN_DIR"

# Replace the previous WSLX data atomically enough for a small shell package:
# remove only our own data directory, recreate it, then copy repository files.
rm -rf "$DATA_DIR"
mkdir -p "$DATA_DIR/lib" "$DATA_DIR/shell/bash" "$DATA_DIR/completions/bash" "$DATA_DIR/docs" "$DATA_DIR/man"

install -m 0755 "$ROOT_DIR/bin/wslx" "$BIN_DIR/wslx"
install -m 0644 "$ROOT_DIR/VERSION" "$DATA_DIR/VERSION"
install -m 0644 "$ROOT_DIR/lib/core.sh" "$DATA_DIR/lib/core.sh"
install -m 0644 "$ROOT_DIR/lib/ui.sh" "$DATA_DIR/lib/ui.sh"
install -m 0644 "$ROOT_DIR/shell/bash/wslx.bash" "$DATA_DIR/shell/bash/wslx.bash"
install -m 0644 "$ROOT_DIR/completions/bash/wslx" "$DATA_DIR/completions/bash/wslx"
install -m 0755 "$ROOT_DIR/uninstall.sh" "$DATA_DIR/uninstall.sh"
install -m 0644 "$ROOT_DIR/man/wslx.1" "$MAN_DIR/wslx.1"

# Keep the two living overview documents available to an installed copy so
# `wslx doctor` can still resolve a complete installation root.
install -m 0644 "$ROOT_DIR/docs/MAP.md" "$DATA_DIR/docs/MAP.md"
install -m 0644 "$ROOT_DIR/docs/ROADMAP.md" "$DATA_DIR/docs/ROADMAP.md"

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

if (( ENABLE_SHELL == 1 )); then
    touch "$BASHRC"

    start_count="$(grep -Fxc "$START_MARKER" "$BASHRC" || true)"
    end_count="$(grep -Fxc "$END_MARKER" "$BASHRC" || true)"

    if [[ "$start_count" != "$end_count" ]]; then
        printf 'WSLX installer: malformed existing managed block in %s; refusing to edit it.\n' "$BASHRC" >&2
        exit 1
    fi

    if (( start_count > 0 )); then
        strip_managed_block "$BASHRC"
    fi

    backup="$BASHRC.wslx-backup-$(date '+%Y%m%dT%H%M%S%z')"
    cp "$BASHRC" "$backup"

    {
        printf '\n%s\n' "$START_MARKER"

        # Expand PREFIX during installation, but preserve the literal "$PATH"
        # expression so Bash expands it later when the user's .bashrc is loaded.
        printf 'export PATH="%s/bin:%s"\n' "$PREFIX" "\$PATH"

        printf 'if [[ -r "%s/shell/bash/wslx.bash" ]]; then source "%s/shell/bash/wslx.bash"; fi\n' "$DATA_DIR" "$DATA_DIR"
        printf 'if [[ -r "%s/completions/bash/wslx" ]]; then source "%s/completions/bash/wslx"; fi\n' "$DATA_DIR" "$DATA_DIR"
        printf '%s\n' "$END_MARKER"
    } >> "$BASHRC"
fi

say "✓ installed: $BIN_DIR/wslx"
if (( ENABLE_SHELL == 1 )); then
    say "✓ Bash integration managed in: $BASHRC"
    say "→ start a new Bash shell, or run: source \"$BASHRC\""
fi
say "→ try: wslx doctor"
