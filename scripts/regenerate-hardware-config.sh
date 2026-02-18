#!/usr/bin/env bash
HOSTNAME=$(hostname)
TOP_LEVEL=$(git rev-parse --show-toplevel)
HARDWARE_CONFIG_DIR="$TOP_LEVEL/NixOSConfig/hardware-configuration/$HOSTNAME/"

nixos-generate-config --show-hardware-config >"$HARDWARE_CONFIG_DIR/default.nix"
cd "$TOP_LEVEL" || exit
if ! [[ $* == *--no-add* ]]; then
  git add .
fi
nix fmt
