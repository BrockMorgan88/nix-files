{ ... }:
{
  programs = {

    # This is a cry for help
    vim = {
      enable = true;
    };

    bash = {
      enable = true;
      enableCompletion = true;
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
