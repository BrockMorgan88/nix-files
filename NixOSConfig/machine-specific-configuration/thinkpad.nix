{ ... }:
{

  # Swap partition
  swapDevices = [
    {
      device = "/dev/nvme0n1p5";
    }
  ];
  networking.hostName = "brock-thinkpad-nixos"; # Define your hostname.
}
