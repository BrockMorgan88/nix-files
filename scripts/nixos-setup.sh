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
  nix-shell -p gh git --command "gh auth login; gh repo clone https://github.com/BrockMorgan88/nix-files.git"
else
  echo "Nix-files repo already cloned. Continuing"
fi
sudo chmod +w ~/nix-files
cd ~/nix-files

HOSTNAME="brock-$1"
mkdir -p ./NixOSConfig/machine-specific-configuration/"$HOSTNAME"
mkdir -p ./homeConfig/machine-specific-home-configuration/"$HOSTNAME"

echo "{ ... }:
{

}" >./NixOSConfig/machine-specific-configuration/"$HOSTNAME"/default.nix

echo "{ ... }:
{

}" >./homeConfig/machine-specific-home-configuration/"$HOSTNAME"/default.nix

nix-shell -p git --command "./scripts/regenerate-hardware-config.sh -h '$1'"
eval "sed -i -e '/systems = \[/a\' -e \"\${userName}-$1\" ./flake.nix"

nix fmt --extra-experimental-features nix-command --extra-experimental-features flakes

nixos-rebuild switch --flake ~/nix-files

direnv allow
