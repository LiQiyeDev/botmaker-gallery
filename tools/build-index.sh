#!/usr/bin/env bash
#
# build-index.sh [gallery-root] — regenerate index.json from bots/*.json.
#
# THE ENTRIES ARE THE SOURCE OF TRUTH AND THIS FILE IS DERIVED — the same layout botmaker-plugin-registry
# uses, and for the same two reasons: two authors publishing on the same day open two pull requests with no
# line in common, and unpublishing is a one-line deletion a maintainer can review rather than a rewritten
# file.
#
# INDEX.JSON MUST NOT MOVE. Studio reads it from
# raw.githubusercontent.com/LiQiyeDev/botmaker-gallery/main/index.json, and every already-shipped Studio has
# that URL compiled into it. The generated array is byte-compatible with what the single-file version held,
# so browsing and installing are unaffected by this change; only PUBLISHING moved.
#
# `sort` because the shell's glob order is locale-dependent, and a regenerated index that reorders itself
# produces a diff nobody can read.
set -euo pipefail

root="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
cd "$root"

entries=()
while IFS= read -r file; do
    entries+=("$file")
done < <(find bots -maxdepth 1 -name '*.json' | sort)

if [ ${#entries[@]} -eq 0 ]; then
    # An empty gallery must still produce valid JSON: Studio parses this file before it has any reason to
    # believe there is anything in it.
    printf '[]\n' > index.json
else
    jq -s '.' "${entries[@]}" > index.json
fi

printf 'index.json: %d entr%s\n' "${#entries[@]}" "$([ ${#entries[@]} -eq 1 ] && echo y || echo ies)" >&2
