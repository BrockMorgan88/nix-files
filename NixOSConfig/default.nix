{ ... }:
{
  imports = [
    ./other.nix
    ./nix-settings.nix
    ./services.nix
    ./packages.nix
    ./hardware-configuration
    ./machine-specific-configuration
  ];
}
