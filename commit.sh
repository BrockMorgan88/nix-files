#!/usr/bin/env bash
set -euo pipefail
if ! [[ $* == *--no-add* ]]; then
  cd "$(git rev-parse --show-toplevel)"
  git add .
  nix fmt
  git add .
fi
git commit -m "$1"
