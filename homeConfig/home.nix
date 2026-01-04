{ config, pkgs, lib, ... }:

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

  wayland.windowManager.sway = {
    checkConfig = true;
    enable = true;
    config = 
    let 
      workspace-1 = "1: ";
      workspace-2 = "2: ";
      workspace-3 = "3: ";
      workspace-4 = "4: ";
      workspace-0 = "0: ";
      modifier = "Mod4";
    in {
      inherit modifier;
      menu = "${pkgs.rofi}/bin/rofi -show drun";
      fonts = {
        names = [ "Iosevka Nerd Font" ];
        style = "Propo";
        size = 11.0;
      };
      window = {
        titlebar = false;
        hideEdgeBorders = "both";
      };
      keybindings = 
      let 
      in lib.mkOptionDefault {
        "${modifier}+1" = "workspace ${workspace-1}";
        "${modifier}+Shift+1" = "move container to workspace ${workspace-1}";
        "${modifier}+2" = "workspace ${workspace-2}";
        "${modifier}+Shift+2" = "move container to workspace ${workspace-2}";
        "${modifier}+3" = "workspace ${workspace-3}";
        "${modifier}+Shift+3" = "move container to workspace ${workspace-3}";
        "${modifier}+4" = "workspace ${workspace-4}";
        "${modifier}+Shift+4" = "move container to workspace ${workspace-4}";
        "${modifier}+0" = "workspace ${workspace-0}";
        "${modifier}+Shift+0" = "move container to workspace ${workspace-0}";
        "Control+${modifier}+T" = "exec --no-startup-id alacritty";
        "${modifier}+Return" = "exec --no-startup-id alacritty";
      };
      assigns = {
        "${workspace-1}" = [{class = "Vivaldi-stable"; }];
        "${workspace-4}" = [{class = "Spotify";}];
        "${workspace-0}" = [{class = "discord";}];
      };
      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          middle_emulation = "enabled";
        };
      };
      bars = [ 
      {
        fonts = {
          names = [ "Iosevka Nerd Font" ];
          style = "Propo";
          size = 9.0;
        };
        mode = "dock";
        position = "bottom";
        statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
        workspaceButtons = true;
        workspaceNumbers = true;
        trayOutput = "*";
        colors = {
          background = "#000000";
          statusline = "#FFFFFF";
          separator = "#666666";
          focusedWorkspace = {
            border = "#4C7899";
            background = "#285577";
            text = "#FFFFFF";
          };
          activeWorkspace = {
            border = "#333333";
            background = "#5F676A";
            text = "#FFFFFF";
          };
          inactiveWorkspace = {
            border = "#333333";
            background = "#222222";
            text = "#888888";
          };
          urgentWorkspace = {
            border = "#2F343A";
            background = "#900000";
            text = "#FFFFFF";
          };
          bindingMode = {
            border = "#2F343A";
            background = "#900000";
            text = "#FFFFFF";
          };
        };
      }];
      startup = [
      {
        always = false;
        command = "Discord";
      }
      {
        always = false;
        command = "alacritty";
      }
      {
        always = true;
        command = "feh --bg-scale ~/nix-files/homeConfig/Background2.jpg";
      }
      ];
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

  programs.alacritty = {
    enable = true;
    settings = {
      env.WINIT_X11_SCALE_FACTOR = "0.9";
      font = {
        normal = {
          family = "Iosevka Nerd Font";
          style = "Regular";
        };
        size = 11;
      };
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/brock/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
