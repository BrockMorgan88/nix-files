#!/usr/bin/env bash

set -euo pipefail

# exit if run as root
if [ "$EUID" -eq 0 ]; then
  echo "Please run as yourself! Running as superuser (ie, with sudo) breaks the setup."
  exit 1
fi

cd ~
if ! [ -d "nix-files" ]; then
    echo "Nix-files repo not found! Cloning now"
    nix-shell -p gh --command "gh auth login; gh repo clone https://github.com/BrockMorgan88/nix-files.git"
else
    echo "Nix-files repo already cloned. Continuing"
fi

cd ~/nix-files

MACHINE_NAME="brock-$1"
mkdir -p ./NixOSConfig/machine-specific-configuration/"$MACHINE_NAME"
mkdir -p ./homeConfig/configs/machine-specific-home-configuration/"$MACHINE_NAME"

echo "{ ... }:
{

}" > ./NixOSConfig/machine-specific-configuration/"$MACHINE_NAME"/default.nix

echo "{ ... }:
{

}" > ./homeConfig/configs/machine-specific-home-configuration/"$MACHINE_NAME"/default.nix

sed -i -e '/systems = \[/a\' -e \"\${userName}-$1\" ./flake.nix
