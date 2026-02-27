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
      pavucontrol # Audio control
      sysstat
      usbutils
      vivaldi
      wget
      wirelesstools
      yazi # CLI file browser
    ]
    ++ (with unstable; [
      bambu-studio
    ])
  );

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  programs.steam.enable = true;
  programs.hyprland.enable = true;
}
