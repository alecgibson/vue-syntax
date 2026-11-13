#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <upstream extensions/vscode dir>" >&2
  exit 64
fi

upstream="$1"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

edit_package_json() {
  local package="$1" filter="$2"
  jq "$filter" "$package" > "$package.tmp"
  mv "$package.tmp" "$package"
}

break_upstream() {
  local name="$1" dir="$2"
  case "$name" in
    missing-grammar) rm -f "$dir/$(jq -r '.contributes.grammars[0].path' "$dir/package.json")" ;;
    supports-restricted-mode) edit_package_json "$dir/package.json" '.capabilities.untrustedWorkspaces = {"supported": "limited"}' ;;
    no-grammars) edit_package_json "$dir/package.json" 'del(.contributes.grammars)' ;;
  esac
}

failed=0
for name in missing-grammar supports-restricted-mode no-grammars; do
  mkdir "$tmp/$name"
  cp -R "$upstream" "$tmp/$name/upstream"
  break_upstream "$name" "$tmp/$name/upstream"
  if "$here/build.sh" "$tmp/$name/upstream" "$tmp/$name/dist" > "$tmp/$name/build.log" 2>&1; then
    echo "FAIL  $name: build.sh accepted it" >&2
    failed=1
  else
    echo "ok    $name"
  fi
done

exit "$failed"
