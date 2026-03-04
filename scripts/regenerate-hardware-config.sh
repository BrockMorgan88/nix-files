#!/usr/bin/env bash
HOSTNAME=$(hostname)
NO_ADD=0
while getopts ":nh:" option; do
  case "$option" in
  n) NO_ADD=1 ;;
  h) HOSTNAME="brock-$OPTARG" ;;
  *)
    echo "ERROR! Incorrect flag!"
    exit 1
    ;;
  esac
done

TOP_LEVEL=$(git rev-parse --show-toplevel)
HARDWARE_CONFIG_DIR="$TOP_LEVEL/NixOSConfig/hardware-configuration/$HOSTNAME/"
mkdir -p "$HARDWARE_CONFIG_DIR"
nixos-generate-config --show-hardware-config >"$HARDWARE_CONFIG_DIR/default.nix"
cd "$TOP_LEVEL" || exit
if ! [[ "$NO_ADD" ]]; then
  git add .
fi
nix fmt --extra-experimental-features nix-command --extra-experimental-features flakes
