{
  lib,
  pkgs,
  unfreeAllowed,
  userName,
  ...
}:
{
  home = {
    username = "${userName}";
    homeDirectory = "/home/${userName}";

    stateVersion = "25.11";

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
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
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;
      ".config/nixpkgs/config.nix".text = ''
        {
          allowUnfree = ${lib.boolToString unfreeAllowed};
        }
      '';
    };
  };
}
