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
      nrsf = "sudo nixos-rebuild switch --flake ~/nix-files/ && sudo /run/current-system/bin/switch-to-configuration boot";
      ngc = "sudo nix-collect-garbage --delete-older-than 7d && sudo /run/current-system/bin/switch-to-configuration boot";
      ngca = "nix-collect-garbage -d && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    };
    initExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  programs.git = {
    enable = true;
    userName = "BrockMorgan88";
    userEmail = "brockjamesmorgan@gmail.com";
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

  programs.vscode = 
  let 
    pythonexts = with pkgs.vscode-extensions.ms-python; [
      vscode-pylance
      python
      debugpy
    ];
    msexts = with pkgs.vscode-extensions.ms-vscode; [
      cpptools
      cpptools-extension-pack
      #cpptools-themes
      cmake-tools
      makefile-tools
    ];
    codeexts = with pkgs.vscode-extensions; [
      mkhl.direnv
      bbenoist.nix
      platformio.platformio-vscode-ide
      christian-kohler.path-intellisense
      vscode-icons-team.vscode-icons
    ];
    better-cpp-syntax = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "better-cpp-syntax";
        publisher = "jeff-hykin";
        version = "1.27.1";
        hash = "sha256-GO/ooq50KLFsiEuimqTbD/mauQYcD/p2keHYo/6L9gw=";
      };
    };
    doxdocgen = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "doxdocgen";
        publisher = "cschlosser";
        version = "1.4.0";
        hash = "sha256-InEfF1X7AgtsV47h8WWq5DZh6k/wxYhl2r/pLZz9JbU=";
      };
    };
    msg = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "msg";
        publisher = "ajshort";
        version = "0.1.1";
        hash = "sha256-aL2znsL/iANHn/xCzAgjsysRTL3k1KxaBtmW/zGCYEI=";
      };
    };
    treefmt = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "treefmt-vscode";
        publisher = "ibecker";
        version = "2.2.1";
        hash = "sha256-3kyEznwTWqdHdCWtoChGBCwRL7tMjtdLI+SQ7TqJh9I=";
      };
    };
    svelte = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "svelte-vscode";
        publisher = "svelte";
        version = "109.12.0";
        hash = "sha256-pPzpP7xYZ2cxj1euA3jj6d0g0c+tK+1is+o4zeMdT/Q=";
      };
    };
    python-environments = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "vscode-python-envs";
        publisher = "ms-python";
        version = "1.12.0";
        hash = "sha256-8dCnGBuxv+8QwP0FrUZIKFxllVOR2z+wIhyyJgxsRns=";
      };
    };
    ros2 = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "vscode-ros2";
        publisher = "jaehyunshim";
        version = "0.0.9";
        hash = "sha256-g0r/IuvAPVYEODAIVql0u2k3uyuK4dYC/tnFgyl4WQQ=";
      };
    };
    python-environment-mgr = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "python-environment-manager";
        publisher = "donjayamanne";
        version = "1.2.7";
        hash = "sha256-w3csu6rJm/Z6invC/TR7tx6Aq5DD77VM62nem8/QMlg=";
      };
    };
    git-patch = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "gitpatch";
        publisher = "paragdiwan";
        version = "0.2.1";
        hash = "sha256-jpdRmTUfwbyJI8ruqHQEcSFwht7HSPrI9r+ZAaNf5Q4=";
      };
    };
    xkb-symbols = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "xkb";
        publisher = "compilouit";
        version = "0.1.2";
        hash = "sha256-k8EmkiebEKB8hDaJqT3KVXy1d9Cc5aUDL9gP1mOBN88=";
      };
    };
    
    otherexts = [
      better-cpp-syntax
      doxdocgen
      msg
      treefmt
      svelte
      python-environments
      ros2
      python-environment-mgr
      git-patch
      xkb-symbols
    ];
  in {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ platformio-core avrdude ]);
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = pythonexts ++ msexts ++ codeexts ++ otherexts;
      userSettings = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "clang-format";
        "[cpp]" = {
          "editor.defaultFormatter" = "ms-vscode.cpptools";
        };
        "C_Cpp.clang_format_style" = "{BasedOnStyle: Google, UseTab: Never, IndentWidth: 4, TabWidth: 4, BreakBeforeBraces: Allman, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false, ColumnLimit: 0, AccessModifierOffset: -4, NamespaceIndentation: All, FixNamespaceComments: false, AlignConsecutiveMacros: true,}";
        "workbench.secondarySideBar.defaultVisibility" = "hidden";
        "workbench.iconTheme" = "vscode-icons";
        "svelte.enable-ts-plugin" = true;
        "editor.fontFamily" = "'Iosevka Nerd Font', 'Regular'";
        "editor.fontSize" = 14;
      };
    };
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = 
    let 
      workspace-1 = "1:  ";
      workspace-2 = "2:  ";
      workspace-3 = "3:  ";
      workspace-4 = "4";
      workspace-0 = "0:  ";
    in {
      modifier = "Mod4";
      fonts = {
        names = [ "Iosevka Nerd Font" ];
        style = "Regular";
        size = 11.0;
      };
      window = {
        titlebar = false;
        hideEdgeBorders = "both";
      };
      keybindings = 
      let 
        modifier = config.xsession.windowManager.i3.config.modifier;
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
      };
      assigns = {
        "${workspace-1}" = [{class = "Vivaldi-stable"; }];
        "${workspace-2}" = [{class = "kitty";}];
        "${workspace-3}" = [{class = "code";}];
        "${workspace-0}" = [{class = "discord";}];
      };
      bars = [ {
        fonts = {
          names = [ "Iosevka Nerd Font" ];
          style = "Regular";
          size = 9.0;
        };
        mode = "dock";
        position = "top";
        statusCommand = "${pkgs.i3status}/bin/i3status";
        workspaceButtons = true;
        workspaceNumbers = true;
        trayOutput = "primary";
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
      } ];
      startup = [
      {
        always = false;
        command = "Discord";
        notification = false;
      }
      {
        always = false;
        command = "kitty";
        notification = false;
      }
      {
        always = true;
        command = "feh --bg-scale ~/nix-files/homeConfig/Background2.jpg";
        notification = false;
      }
      ];
    };
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    general = {
      colors = true;
      color_good = "#47bd5f";
      color_bad = "#FF0000";
      color_degraded = "#9b410d";
      interval = 10;
    };
    modules = 
    let 
      num_modules = 6;
    in {
      "disk /" = {
        enable = true;
        position = num_modules - 8;
        settings = {
          format = "  %percentage_used used %percentage_free free %percentage_avail available";
          prefix_type = "custom";
          low_threshold = 10;
          threshold_type = "percentage_free";
          format_below_threshold = "    %percentage_avail available";
        };
      };
      "wireless wlp0s20f3" = {
        enable = true;
        position = num_modules - 7;
        settings = {
          format_up = "  Quality %quality %essid %bitrate %frequency %ip";
          format_down = "󰖪 ";
          format_quality = "%02d%s";
        };
      };
      "ethernet enp0s31f6" = {
        enable = true;
        position = num_modules - 6;
        settings = {
          format_up = "󰈁 %ip (%speed)";
          format_down = "󰈂 ";
        };
      };
      "memory" = {
        enable = true;
        position = num_modules - 5;
        settings = {
          memory_used_method = "classical";
          format = "  %free free %available available %used/%total used";
          unit = "auto";
        };
      };
      "cpu_usage" = {
        enable = true;
        position = num_modules - 3;
        settings = {
          format = "  %usage";
          max_threshold = 75;
          format_above_threshold = "    %usage";
        };
      };
      "load" = {
        enable = true;
        position = num_modules - 2;
        settings = {
          format = "1m: %1min 5m: %5min";
          max_threshold = 10;
          format_above_threshold = "  1m: %1min 5m: %5min";
        };
      };
      "battery all" = {
        enable = true;
        position = num_modules;
        settings = {
          format = "%status %remaining (%percentage %consumption)";
          format_down = "No battery!";
          format_percentage = "%.02f%s";
          status_chr = "󰂄";
          status_bat = "󰁾";
          status_unk = "󰂃";
          status_full = "󰁹";
          low_threshold = 10;
          threshold_type = "percent";
          path = "/sys/class/power_supply/BAT%d/uevent";
        };
      };
      "time" = {
        enable = true;
        position = num_modules;
        settings = {
          format = "%d-%m-%Y %H:%M";
        };
      };
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 11;
    };
    themeFile = "Hybrid";
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
