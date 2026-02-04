#!/usr/bin/env bash
if ! [[ "$*" == *--no-add* ]]; then
    cd ~/nix-files/
    git add .
    treefmt
    git add .
fi
git commit -m "$1"