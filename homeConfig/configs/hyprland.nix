{ pkgs, ... }:
{
  wayland.windowManager.hyprland =
    let
      workspaceNames = [
        "Browser" # 1
        "Terminal" # 2
        "VSCode" # 3
        "Spotify" # 4
        "" # 5
        "" # 6
        "" # 7
        "" # 8
        "" # 9
        "Discord" # 10
      ];
    in
    {
      systemd.variables = [ "--all" ];
      enable = true;
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
          "$mod, code:113, movefocus, l"
          "$mod, code:114, movefocus, r"
          "$mod, code:111, movefocus, u"
          "$mod, code:116, movefocus, d"
          "$mod+SHIFT, code:113, movewindow, l"
          "$mod+SHIFT, code:114, movewindow, r"
          "$mod+SHIFT, code:111, movewindow, u"
          "$mod+SHIFT, code:116, movewindow, d"
          "$mod, L, exec, hyprlock"
          ", switch:on:Lid Switch, exec, hyprlock"
          "$mod, R, submap, resize"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 10
        ));
        decoration = {
          blur.enabled = false;
          shadow.enabled = false;
        };
        misc = {
          vfr = true;
        };
        monitor = [
          "eDP-1, 1920x1200@120, 0x0, 1"
        ];
        animation = [
          "workspaces, 1, 0.5, default"
          "windows, 1, 0.5, default"
        ];
        windowrule = [
          "opacity 1.0 0.9, rounding 10, class:(?s).*"
        ];
        workspace = [
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "${toString ws}, gapsout:4, gapsin:4, defaultName:${builtins.elemAt workspaceNames i}"
            ]
          ) 10
        ));
      };
      submaps = {
        resize = {
          settings = {
            bind = [
              ", code:113, resizeactive, -20 0"
              ", code:114, resizeactive, 20 0"
              ", code:111, resizeactive, 0 -20"
              ", code:116, resizeactive, 0 20"
              ", Escape, submap, reset"
            ];
          };
        };
      };
    };
}
