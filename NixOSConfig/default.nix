{ ... }:
{
  imports = [
    ./other.nix
    ./nix-settings.nix
    ./services.nix
    ./hardware-configuration
    ./machine-specific-configuration
  ];
}
