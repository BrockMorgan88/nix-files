#!/usr/bin/env bash
if ! [[ $* == *--no-add* ]]; then
  cd ~/nix-files/ || exit
  git add .
  nix fmt
  git add .
fi
git commit -m "$1"
