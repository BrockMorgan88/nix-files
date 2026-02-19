{ ... }:
{
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
  services.displayManager.ly.settings.battery_id = "BAT0";
}
