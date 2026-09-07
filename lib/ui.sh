#!/usr/bin/env bash
# Shared terminal UI helpers.
#
# This file owns presentation only: colors, status symbols and small printing
# helpers. Keeping UI separate prevents command logic from being coupled to
# ANSI escape sequences.

# Enable colors only for an interactive terminal and when NO_COLOR is unset.
#
# These variables form part of the shared UI library API. Some of them are
# consumed by scripts that source this file, so ShellCheck cannot always see
# their usage when ui.sh is analyzed independently.
# shellcheck disable=SC2034
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    WSLX_RED=$'\033[31m'
    WSLX_GREEN=$'\033[32m'
    WSLX_YELLOW=$'\033[33m'
    WSLX_CYAN=$'\033[36m'
    WSLX_BOLD=$'\033[1m'
    WSLX_RESET=$'\033[0m'
else
    WSLX_RED=""
    WSLX_GREEN=""
    WSLX_YELLOW=""
    WSLX_CYAN=""
    WSLX_BOLD=""
    WSLX_RESET=""
fi

wslx_info() {
    printf '%s→%s %s\n' "$WSLX_CYAN" "$WSLX_RESET" "$*"
}

wslx_success() {
    printf '%s✓%s %s\n' "$WSLX_GREEN" "$WSLX_RESET" "$*"
}

wslx_warn() {
    printf '%s⚠%s %s\n' "$WSLX_YELLOW" "$WSLX_RESET" "$*" >&2
}

wslx_error() {
    printf '%s✗%s %s\n' "$WSLX_RED" "$WSLX_RESET" "$*" >&2
}
