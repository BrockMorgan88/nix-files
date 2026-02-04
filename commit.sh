#!/usr/bin/env bash
cd ~/nix-files/
git add .
treefmt
git add .
git commit -m "$1"