{ ... }:
{
  imports = [
    ./vscode.nix
    ./hyprland.nix
    ./waybar.nix
    ./other.nix
    ./home-settings.nix
    ./programs.nix
    ./machine-specific-home-configuration
  ];
}
