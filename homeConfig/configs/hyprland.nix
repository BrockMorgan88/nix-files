{ pkgs, ... }:
{
  wayland.windowManager.hyprland =
    let
      workspaceNames = [
        "Browser" # 1
        "Terminal" # 2
        "VSCode" # 3
        "4" # 4
        "5" # 5
        "6" # 6
        "7" # 7
        "8" # 8
        "9" # 9
        "10" # 10
        "11" # 11
        "Discord" # 12
      ];
    in
    {
      portalPackage = pkgs.xdg-desktop-portal-gtk;
      systemd.variables = [ "--all" ];
      enable = true;
      package = null;
      settings = {
        "$mod" = "SUPER";
        bind = [
          "$mod, Return, exec, kitty"
          "$mod, S, exec, ${pkgs.rofi}/bin/rofi -show drun"
          "$mod, Q, killactive"
          "$mod+SHIFT, Q, forcekillactive"
          "$mod, V, exec, vivaldi"
          "$mod, D, exec, discord"
          "$mod, F, togglefloating, active"
          "$mod+SHIFT, R, exec, hyprctl reload"
          "$mod, F12, fullscreen"
          # Arrows for switching windows
          "$mod, code:113, movefocus, l"
          "$mod, code:114, movefocus, r"
          "$mod, code:111, movefocus, u"
          "$mod, code:116, movefocus, d"
          # Arrows for moving windows
          "$mod+SHIFT, code:113, movewindow, l"
          "$mod+SHIFT, code:114, movewindow, r"
          "$mod+SHIFT, code:111, movewindow, u"
          "$mod+SHIFT, code:116, movewindow, d"
          "$mod, L, exec, hyprlock"
          ", switch:on:Lid Switch, exec, hyprlock"
          "$mod, R, submap, Resize"
        ]
        # Workspaces 1-12 - keys 1-=
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:${toString (i + 10)}, workspace, ${toString ws}"
              "$mod SHIFT, code:${toString (i + 10)}, movetoworkspace, ${toString ws}"
            ]
          ) 12
        ));
        decoration = {
          blur.enabled = false;
          shadow.enabled = false;
        };
        misc = {
          vfr = true;
        };
        # Set all unspecified monitors (machine-specific) to their preferred resolution,
        # on the left of the others, with a scale of 1
        monitor = [
          ", preferred, left, 1"
        ];
        animation = [
          "workspaces, 1, 0.5, default"
          "windows, 1, 0.5, default"
        ];
        windowrule = [
          # Transparent windows (0.9) when not focused, rounded corners, all window classes (REGEX)
          "opacity 1.0 0.9, rounding 10, class:(?s).*"
        ];
        workspace = [
        ]
        # The default window gaps are horrible - make them smaller, assign the default names as in workspaceNames
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "${toString ws}, gapsout:4, gapsin:4, defaultName:${builtins.elemAt workspaceNames i}"
            ]
          ) (builtins.length workspaceNames)
        ));
        exec-once = [
          # Anime girl background :)
          "${pkgs.swaybg}/bin/swaybg -i /home/brock/nix-files/homeConfig/configs/Background.png "
        ];
      };
      submaps = {
        Resize = {
          settings = {
            bind = [
              ", code:113, resizeactive, -20 0"
              ", code:114, resizeactive, 20 0"
              ", code:111, resizeactive, 0 -20"
              ", code:116, resizeactive, 0 20"
              "SHIFT, code:113, resizeactive, -100 0"
              "SHIFT, code:114, resizeactive, 100 0"
              "SHIFT, code:111, resizeactive, 0 -100"
              "SHIFT, code:116, resizeactive, 0 100"
              ", Escape, submap, reset"
            ];
          };
        };
      };
    };
}
