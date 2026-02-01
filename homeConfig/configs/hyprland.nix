{ pkgs, ... }:
{
  wayland.windowManager.hyprland =
    let
      workspaceNames = [
        "Browser" # 1
        "Terminal" # 2
        "VSCode" # 3
        "Spotify" # 4
        "5" # 5
        "6" # 6
        "7" # 7
        "8" # 8
        "9" # 9
        "Discord" # 10
        "11" # 11
        "12" # 12
        "13" # 13
        "14" # 14
        "15" # 15
        "16" # 16
        "17" # 17
        "18" # 18
        "19" # 19
        "20" # 20
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
          "$mod, K, killactive"
          "$mod+SHIFT, K, forcekillactive"
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
          # MOD+\ to resize - '\' doesn't work well when naming it directly as it's a special character
          "$mod, code:51, submap, Resize"
        ]
        # Workspaces 1-10 - keys 1-0
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
        ))
        # Workspaces 11-20 - keys q-p
        ++ builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 11;
            in
            [
              "$mod, code:${toString (i + 24)}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString (i + 24)}, movetoworkspace, ${toString ws}"
            ]
          ) 10
        );
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
          ) 20
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
