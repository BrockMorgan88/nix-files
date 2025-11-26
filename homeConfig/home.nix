{ config, pkgs, ... }:

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
    bash
    curl
    dconf
    dconf-editor
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
      nrsf = "sudo nixos-rebuild switch --flake ~/nix-files/";
      ngc = "sudo nix-collect-garbage --delete-older-than 30d";
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
    cppexts = with pkgs.vscode-extensions.ms-vscode; [
      cpptools
      cpptools-extension-pack
      #cpptools-themes
      cmake-tools
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
    otherexts = [
      better-cpp-syntax
      doxdocgen
      msg
      treefmt
      svelte
    ];
  in {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ platformio-core avrdude ]);
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = pythonexts ++ cppexts ++ codeexts ++ otherexts;
    };
  };

  dconf = {
    settings = {
      "org/gnome/shell/extensions/appindicator" = {
        icon-brightness = 0.0;
        icon-contrast = 0;
        icon-opacity = 255;
        icon-saturation = 0.0;
        icon-size = 0;
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
