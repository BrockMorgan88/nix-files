{ hostName, ... }:
{
  imports = [
    ./other.nix
    ./nix-settings.nix
    ./services.nix
    ./hardware-configuration/${hostName}
    ./machine-specific-configuration/${hostName}
  ];
}
