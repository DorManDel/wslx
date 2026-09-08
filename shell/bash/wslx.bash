#!/usr/bin/env bash
# WSLX Bash integration.
#
# Most WSLX commands run as normal child processes. Commands that must change
# the current shell itself belong here. `cd` is the first such command because
# a child process cannot change its parent Bash process's working directory.

export WSLX_SHELL_INTEGRATION=1

_wslx_cd_help() {
    cat <<'EOF_HELP'
Usage:
  wslx cd <path>
  wcd <path>

The path may be a Windows path, WSL/Linux path, or relative path.

Examples:
  wslx cd 'D:\Programming\Scripts'
  wcd /mnt/d/Programming/Scripts
  wcd './folder with spaces'
EOF_HELP
}

_wslx_cd() {
    local input target

    if (( $# > 0 )) && [[ "$1" == "-h" || "$1" == "--help" ]]; then
        if (( $# != 1 )); then
            printf 'wslx cd: --help does not accept operands\n' >&2
            return 2
        fi
        _wslx_cd_help
        return 0
    fi

    if (( $# > 0 )) && [[ "$1" == "--" ]]; then
        shift
    fi

    if (( $# != 1 )); then
        printf 'wslx cd: exactly one directory is required\n' >&2
        return 2
    fi

    input="$1"

    # A child WSLX process only computes the destination. It exits before the
    # parent Bash process performs the state-changing cd.
    if ! target="$(command wslx path --wsl "$input")"; then
        printf 'wslx cd: failed to normalize path: %s\n' "$input" >&2
        return 1
    fi

    if [[ ! -e "$target" ]]; then
        printf 'wslx cd: directory does not exist: %s\n' "$target" >&2
        return 1
    fi

    if [[ ! -d "$target" ]]; then
        printf 'wslx cd: not a directory: %s\n' "$target" >&2
        return 1
    fi

    # This builtin runs in the current Bash process. Bash ultimately changes
    # its own working directory through chdir(2).
    builtin cd -- "$target" || return 1
}

wcd() {
    _wslx_cd "$@"
}

wslx() {
    if [[ "${1-}" == "cd" ]]; then
        shift
        _wslx_cd "$@"
        return
    fi

    command wslx "$@"
}
