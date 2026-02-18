{ hostName, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration/${hostName}
    ./machine-specific-configuration/${hostName}
  ];
}
