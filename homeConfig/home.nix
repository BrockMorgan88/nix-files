{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brock";
  home.homeDirectory = "/home/brock";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    curl
    ethtool
    tree
    usbutils
    zip
  ];

  imports = [
    ./configs
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Programs and program configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      nrsf = "sudo nixos-rebuild switch --flake ~/nix-files/";
      ngc = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d && sudo /run/current-system/bin/switch-to-configuration boot";
      ngca = "sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    };
    initExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "BrockMorgan88";
      email = "brockjamesmorgan@gmail.com";
    };
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
      size = 12;
    };
  };

  programs.i3blocks = {
    enable = true;
    bars = {
      config = {
        disk = {
          command = "~/nix-files/homeConfig/scripts/disk.sh";
          interval = 10;
        };
        wifi = lib.hm.dag.entryAfter [ "disk" ] {
          command = "~/nix-files/homeConfig/scripts/wifi.sh";
          interval = 10;
        };
        ethernet = lib.hm.dag.entryAfter [ "wifi" ] {
          command = "~/nix-files/homeConfig/scripts/ethernet.sh";
          interval = 10;
        };
        ram = lib.hm.dag.entryAfter [ "ethernet" ] {
          command = "~/nix-files/homeConfig/scripts/ram.sh";
          interval = 10;
        };
        swap = lib.hm.dag.entryAfter [ "ram" ] {
          command = "~/nix-files/homeConfig/scripts/swap.sh";
          interval = 10;
        };
        cpu = lib.hm.dag.entryAfter [ "swap" ] {
          command = "~/nix-files/homeConfig/scripts/cpu.sh";
          interval = 10;
        };
        battery = lib.hm.dag.entryAfter [ "cpu" ] {
          command = "~/nix-files/homeConfig/scripts/battery.sh";
          interval = 10;
        };
        time = lib.hm.dag.entryAfter [ "battery" ] {
          command = "date +'%d-%m-%Y %H:%M'";
          interval = 10;
          color = "#FFFFFF";
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainbar = {
        layer = "top";
        position = "bottom";
        height = 22;
        output = [
          "eDP-1"
        ];
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "battery"
          "cpu"
          "tray"
        ];
        "battery" = {
          "format" = "BAT: {capacity}%";
          "on-discharging-20" =
            "notify-send --urgency=critical --app-name=i3blocks 'BATTERY LOW' 'Plug in your battery now!'";
        };
        "cpu" = {
          "format" = "CPU: {usage}%";
        };
      };
    };
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

  programs.hyprlock = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      size = 11;
      name = "Iosevka Nerd Font";
    };
  };

  programs.home-manager.enable = true;
}
