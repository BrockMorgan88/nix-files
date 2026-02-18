{
  pkgs,
  unfreeAllowed,
  lib,
  userName,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${userName}";
  home.homeDirectory = "/home/${userName}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    curl
    discord
    ethtool
    evince # Gnome document viewer
    kicad-unstable-small
    gnome-calculator
    gnome-text-editor
    libreoffice-fresh
    swaybg
    slurp # Part of screenshot
    spotify
    grim # Part of screenshot
    wl-clipboard # Part of screenshot
    zellij
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = ${lib.boolToString unfreeAllowed};
      }
    '';
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # This is a cry for help
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  xdg.portal = {
    enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [
          "gtk"
          "hyprland"
        ];
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      nrsf = "sudo nixos-rebuild switch --flake ~/nix-files/";
      hmsf = "home-manager switch --flake ~/nix-files/";
      ngc = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d && sudo /run/current-system/bin/switch-to-configuration boot";
      ngca = "sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      screenshot = "slurp | grim -g - - | wl-copy";
    };
    initExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = builtins.fromTOML ''
      [global]
      hide_env_diff = true
    '';
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    font = {
      name = "Iosevka Nerd Font";
      size = 10.5;
    };
    colorScheme = "dark";
  };

  programs.kitty = {
    enable = true;
    font = {
      size = 10.5;
      name = "Iosevka Nerd Font Mono";
    };
    enableGitIntegration = true;
    shellIntegration.enableBashIntegration = true;
  };

  programs.rofi = {
    enable = true;
    font = "Iosevka Nerd Font Mono 12";
    theme = "Arc-Dark";
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
  programs.home-manager.enable = true;
}
