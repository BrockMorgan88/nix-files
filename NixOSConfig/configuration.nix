# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  hostName,
  userName,
  ...
}:

{
  # EFI boot loader.
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      default = "saved";
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  networking = {
    networkmanager.enable = true; # Enables wireless support via wpa_supplicant.
    firewall.enable = false;
    inherit hostName;
  };
  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      battery_id = "BAT0";
      bigclock = "en";
      vi_mode = true;
      vi_default_mode = "insert";
    };
  };

  programs.hyprland = {
    enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userName} = {
    isNormalUser = true;
    description = "Brock Morgan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
    ];
  };

  environment.systemPackages = (
    with pkgs;
    [
      bluez # Bluetooth
      btop
      discord
      dunst
      evince # Gnome document viewer
      git
      git-credential-manager
      gh
      gnome-calculator
      gnome-text-editor
      home-manager
      kicad-unstable-small
      libreoffice-fresh
      libnotify # Notify-send
      lm_sensors
      nixd
      pavucontrol # Audio control
      spotify
      sysstat
      vscode
      vite # For web dev stuff
      vivaldi
      wget
      wirelesstools
      yarn # For web dev stuff
      yazi # CLI file browser
      zellij
      zsh
    ]
    # ++ (with unstable; [
    # ])
  );

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  nix.settings = {

    auto-optimise-store = true;
    download-buffer-size = 134217728;
    # To be able to run nix "command" instead of nix-command and to use flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    warn-dirty = false;

    # Setup trusted substituters for perseus repo
    trusted-substituters = [
      "https://roar-qutrc.cachix.org"
      "https://ros.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "roar-qutrc.cachix.org-1:ZKgHZSSHH2hOAN7+83gv1gkraXze5LSEzdocPAEBNnA="
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];

    # Keep direnv stuff
    keep-derivations = true;
    keep-outputs = true;

    cores = 12;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
