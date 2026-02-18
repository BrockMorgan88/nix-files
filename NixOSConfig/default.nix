{ hostName, ... }:
{
  imports = [
    ./configuration.nix
    ./nix-settings.nix
    ./hardware-configuration/${hostName}
    ./machine-specific-configuration/${hostName}
  ];
}
