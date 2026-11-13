#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <upstream extensions/vscode dir> <out dir>" >&2
  exit 64
fi

upstream="$1"
out="$2"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if jq -e '.capabilities.untrustedWorkspaces.supported | IN(true, "limited")' "$upstream/package.json" >/dev/null; then
  echo "Vue (Official) now supports Restricted Mode itself. Deprecate alecgibson.vue-syntax in favour of Vue.volar instead of publishing it." >&2
  exit 1
fi

mkdir "$out"
cp -R "$upstream/syntaxes" "$upstream/languages" "$upstream/LICENSE" "$here/README.md" "$out/"

jq --slurpfile upstream "$upstream/package.json" '
  . + ($upstream[0] |
    if (.contributes.languages and .contributes.grammars) then
      {version, engines, contributes: (.contributes | {languages, grammars})}
    else
      error("upstream package.json has no contributes.languages or contributes.grammars")
    end)
' "$here/package.template.json" > "$out/package.json"

referenced="$(jq -r '.contributes | .. | strings | select(startswith("./"))' "$out/package.json")"
while IFS= read -r path; do
  if [[ ! -f "$out/$path" ]]; then
    echo "$path is in package.json but not in $upstream" >&2
    exit 1
  fi
done <<<"$referenced"
