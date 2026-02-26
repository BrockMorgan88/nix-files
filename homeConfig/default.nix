{ inputs, ... }:
{
  imports = [
    ./vscode.nix
    ./hyprland.nix
    ./waybar.nix
    ./other.nix
    ./home-settings.nix
    ./programs.nix
    inputs.nixvim.homeModules.nixvim
    ./nixvim.nix
    ./machine-specific-home-configuration
  ];
}
