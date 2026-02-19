{ pkgs, ... }:
{
  environment.systemPackages = (
    with pkgs;
    [
      bluez # Bluetooth
      brightnessctl
      btop
      curl
      dunst # Notifications
      ethtool
      git
      gh
      home-manager
      libnotify # Notify-send
      lm_sensors
      nixd
      pavucontrol # Audio control
      sysstat
      usbutils
      vivaldi
      wget
      wirelesstools
      yazi # CLI file browser
    ]
    # ++ (with unstable; [
    # ])
  );

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  programs.steam.enable = true;
  programs.hyprland.enable = true;
}
