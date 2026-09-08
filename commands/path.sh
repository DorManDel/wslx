#!/usr/bin/env bash
# WSLX path interoperability.
#
# Default behavior returns a path that is usable in the current WSL shell:
#   - Windows drive paths are converted to WSL form.
#   - Paths already in WSL/Linux form are returned unchanged.
#
# Explicit modes can request WSL form, Windows form, or an interactive
# clickable Windows link. Conversion is delegated to WSL's native `wslpath`.

wslx_path_help() {
    cat <<'EOF_HELP'
Usage:
  wslx <path>
  wslx path <path>
  wslx --wsl <path>
  wslx --win <path>
  wslx --link <path>

Readable form:
  wslx path [--wsl|--win|--link] <path>

Options:
  --wsl        Return a WSL-usable path (default)
  --win        Return the Windows representation
  --link       Show the Windows representation as a clickable terminal link
  -h, --help   Show this help

Examples:
  wslx 'D:\Programming\Test'
  wslx path '/mnt/d/Programming/Test'
  wslx --win '/mnt/d/Programming/Test'
  wslx --link '/mnt/d/Programming/Test'
EOF_HELP
}

wslx_path_is_windows() {
    [[ "$1" =~ ^[A-Za-z]:[\\/].* ]]
}

wslx_path_require_wslpath() {
    if wslx_require_command wslpath; then
        return 0
    fi

    wslx_error "path: wslpath is not available"
    return 1
}

wslx_path_to_wsl() {
    local input="$1"

    if wslx_path_is_windows "$input"; then
        wslx_path_require_wslpath || return 1
        wslpath -u "$input"
        return
    fi

    # Linux/WSL paths are already usable in WSL. Do not flip them to Windows.
    printf '%s\n' "$input"
}

wslx_path_to_windows() {
    local input="$1"

    if wslx_path_is_windows "$input"; then
        printf '%s\n' "$input"
        return
    fi

    wslx_path_require_wslpath || return 1
    wslpath -w "$input"
}

wslx_path_windows_file_uri() {
    local windows_path="$1"
    local slash_path uri

    slash_path="${windows_path//\\//}"

    if [[ "$slash_path" =~ ^([A-Za-z]):/(.*)$ ]]; then
        uri="file:///${BASH_REMATCH[1]}:/${BASH_REMATCH[2]}"
    else
        uri="file:///${slash_path#/}"
    fi

    # Minimal URI escaping for common path characters.
    uri="${uri//%/%25}"
    uri="${uri// /%20}"
    uri="${uri//#/%23}"
    uri="${uri//\?/%3F}"

    printf '%s\n' "$uri"
}

wslx_path_print_link() {
    local input="$1"
    local windows_path uri

    windows_path="$(wslx_path_to_windows "$input")" || return

    # Keep pipes/scripts clean. Hyperlink escape sequences are presentation,
    # so they are emitted only when stdout is an interactive terminal.
    if [[ -t 1 && "${TERM:-dumb}" != "dumb" ]]; then
        uri="$(wslx_path_windows_file_uri "$windows_path")"
        printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$uri" "$windows_path"
    else
        printf '%s\n' "$windows_path"
    fi
}

wslx_path_main() {
    local mode="wsl"
    local input=""

    while (( $# > 0 )); do
        case "$1" in
            --wsl)
                mode="wsl"
                shift
                ;;
            --win)
                mode="win"
                shift
                ;;
            --link)
                mode="link"
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

    case "$mode" in
        wsl)
            wslx_path_to_wsl "$input"
            ;;
        win)
            wslx_path_to_windows "$input"
            ;;
        link)
            wslx_path_print_link "$input"
            ;;
    esac
}
