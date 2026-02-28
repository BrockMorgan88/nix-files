{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./other.nix
    ./home-settings.nix
    ./programs.nix
    inputs.nvf.homeManagerModules.default
    ./neovim.nix
    ./machine-specific-home-configuration
  ];
}
