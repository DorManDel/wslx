#!/usr/bin/env bash
# PathX command implementation.
#
# Responsibility:
#   Convert paths between Windows and WSL formats.
#   Automatic mode determines the direction from the input path.
#
# Conversion itself is delegated to WSL's native `wslpath` utility.

wslx_path_help() {
    cat <<'EOF_HELP'
Usage:
  wslx path <path>
  wslx path --to-wsl <path>
  wslx path --to-windows <path>

Options:
  --to-wsl       Convert a Windows path to WSL format
  --to-windows   Convert a WSL path to Windows format
  -h, --help     Show this help

Examples:
  wslx path 'D:\Programming\Test'
  wslx path '/mnt/d/Programming/Test'
  wslx path --to-wsl 'D:\Programming\Test'
  wslx path --to-windows '/mnt/d/Programming/Test'
EOF_HELP
}

wslx_path_main() {
    local mode="auto"
    local input=""

    while (( $# > 0 )); do
        case "$1" in
            --to-wsl)
                mode="to-wsl"
                shift
                ;;
            --to-windows)
                mode="to-windows"
                shift
                ;;
            -h|--help)
                wslx_path_help
                return 0
                ;;
            -*)
                wslx_error "path: unknown option: $1"
                return 2
                ;;
            *)
                break
                ;;
        esac
    done

    if (( $# != 1 )); then
        wslx_error "path: exactly one path is required"
        return 2
    fi

    input="$1"

    if ! wslx_require_command wslpath; then
        wslx_error "path: wslpath is not available"
        return 1
    fi

    case "$mode" in
        to-wsl)
            wslpath -u "$input"
            ;;

        to-windows)
            wslpath -w "$input"
            ;;

        auto)
            if [[ "$input" =~ ^[A-Za-z]:[\\/].* ]]; then
                wslpath -u "$input"
            elif [[ "$input" == /* ]]; then
                wslpath -w "$input"
            else
                wslx_error "path: cannot detect path type: $input"
                return 2
            fi
            ;;
    esac
}