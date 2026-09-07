#!/usr/bin/env bash
# Shared non-UI foundation helpers.
#
# Command modules should depend on these helpers instead of reimplementing
# environment detection or version loading.

wslx_is_wsl() {
    # WSL kernels normally expose "microsoft" or "WSL" in the kernel release.
    grep -qiE '(microsoft|wsl)' /proc/sys/kernel/osrelease 2>/dev/null ||
        grep -qi 'microsoft' /proc/version 2>/dev/null
}

wslx_version() {
    # WSLX_ROOT is resolved by the entry point before this library is sourced.
    cat "$WSLX_ROOT/VERSION"
}

wslx_require_command() {
    local command_name="$1"
    command -v "$command_name" >/dev/null 2>&1
}
