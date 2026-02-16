{ hostName, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration/${hostName}/hardware-configuration.nix
    ./machine-specific-configuration/${hostName}
  ];
}
