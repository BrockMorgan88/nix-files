{ ... }:
{
  programs = {

    # This is a cry for help
    vim = {
      enable = true;
      defaultEditor = true;
    };

    bash = {
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

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
      config = builtins.fromTOML ''
        [global]
        hide_env_diff = true
      '';
    };

    kitty = {
      enable = true;
      font = {
        size = 10.5;
        name = "Iosevka Nerd Font Mono";
      };
      enableGitIntegration = true;
      shellIntegration.enableBashIntegration = true;
    };

    rofi = {
      enable = true;
      font = "Iosevka Nerd Font Mono 12";
      theme = "Arc-Dark";
    };
    home-manager.enable = true;
  };
}
