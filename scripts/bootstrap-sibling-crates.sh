#!/usr/bin/env bash
# Clone or link embeddenator component repos next to embeddenator-core for path dependencies.
set -euo pipefail

core_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
parent="$(dirname "$core_root")"
org="https://github.com/tzervas"

crates=(
  embeddenator-vsa
  embeddenator-retrieval
  embeddenator-fs
  embeddenator-interop
  embeddenator-io
  embeddenator-obs
  embeddenator-cli
)

for name in "${crates[@]}"; do
  dest="${parent}/${name}"
  if [[ -f "${dest}/Cargo.toml" ]]; then
    echo "ok: ${dest}"
    continue
  fi
  super="${parent}/embeddenator/${name}"
  if [[ -f "${super}/Cargo.toml" ]]; then
    echo "link: ${dest} -> ${super}"
    ln -sfn "${super}" "${dest}"
    continue
  fi
  echo "clone: ${name} -> ${dest}"
  git clone --depth 1 "${org}/${name}.git" "${dest}"
done

echo "Sibling crates ready under ${parent}"