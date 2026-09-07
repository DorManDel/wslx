#!/usr/bin/env bash
# Create a timestamped development record using the local timezone.

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
NAME="${1:-}"

if [[ -z "$NAME" ]]; then
    printf 'Usage: %s <short-change-name>\n' "$0" >&2
    exit 2
fi

slug="$(printf '%s' "$NAME" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9._-')"
[[ -n "$slug" ]] || { printf 'Change name produced an empty slug.\n' >&2; exit 2; }

timestamp_iso="$(date '+%Y-%m-%dT%H:%M:%S%:z')"

# File names avoid ":" because the repository may live on a Windows-mounted
# filesystem where colon is not a portable filename character.
timestamp_file="$(date '+%Y-%m-%dT%H-%M-%S%:z' | tr ':' '-')"

version="$(cat "$ROOT_DIR/VERSION")"
out="$ROOT_DIR/docs/changes/${timestamp_file}-${slug}.md"


# This heredoc intentionally expands change metadata such as the name,
# timestamp and version.
#
# Markdown backticks inside the template must therefore be escaped.
# Without the backslash, Bash treats `...` as command substitution and
# attempts to execute the text between the backticks.
cat > "$out" <<EOF_RECORD
# $NAME

Timestamp: $timestamp_iso  
Version: $version

## Goal

Describe the purpose of this change.

## Mapxplanation Update

Describe what changed in \`docs/MAP.md\` and why.

## Files Changed

- TODO

## Why

- TODO

## Validation

- [ ] \`make test\`
- [ ] \`make lint\`
- [ ] \`make check\`

## Result

- TODO

## Next

- TODO
EOF_RECORD

printf '%s\n' "$out"
