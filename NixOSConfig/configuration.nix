# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Swap partition
  swapDevices = [ {
    device = "/dev/nvme0n1p5";
  } ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "brock-thinkpad-nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true; # Allow Unfree packages (like vs code and discord)

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Exclude unused GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    gnome-weather
    decibels
    geary
    simple-scan
    totem
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
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
  
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brock = {
    isNormalUser = true;
    description = "Brock Morgan";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [
      home-manager
    ];
  };
environment.systemPackages = with pkgs; [
    btop
    direnv
    discord
    git
    gh
    libreoffice-fresh
    platformio
    python3
    spotify
    vscode.fhs
    vite
    vivaldi
    wget
    yarn
    zellij
    zsh

    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dock-from-dash
    gnomeExtensions.just-perfection
  ];

  services.udev.packages = with pkgs; [ 
    gnome-settings-daemon
    platformio-core
    openocd
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      python3
      pipenv
    ];
  };

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";

   
  nix.settings = {

    auto-optimise-store = true;

    # To be able to run nix "command" instead of nix-command and to use flakes 
    experimental-features = [ "nix-command" "flakes" ];
    
    warn-dirty = false;

    trusted-users = [
      "brock"
    ];

    # Setup trusted substituters for perseus repo
    trusted-substituters = [
      "https://roar-qutrc.cachix.org"
      "https://ros.cachix.org"
    ];
    trusted-public-keys = [
      "roar-qutrc.cachix.org-1:ZKgHZSSHH2hOAN7+83gv1gkraXze5LSEzdocPAEBNnA="
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
    ];

    # Keep direnv stuff
    keep-derivations = true;
    keep-outputs = true;
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
  # networking.firewall.enable = false;

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
  system.stateVersion = "25.05"; # Did you read the comment?

}

