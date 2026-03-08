{ pkgs, ... }:
{
  home.packages = with pkgs; [
    slurp # Part of screenshot
    grim # Part of screenshot
    wl-clipboard # Part of screenshot
  ];
  home.shellAliases = {
    screenshot = "slurp | grim -g - - | wl-copy";
  };
}
