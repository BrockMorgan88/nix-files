{ ... }:
{
  imports = [
    ./vscode.nix
    ./hyprland.nix
    ./waybar.nix
    ./machine-specific-home-configuration
    ./other.nix
  ];
}
