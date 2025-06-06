{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$browser" = userSettings.browser;
    "$term" = userSettings.terminal;
    "$filemanager" = userSettings.fileManager;

    bind = [

      #________Application Keybinds________#
      "$mod, F, exec, $browser"
      "$mod, E, exec, $filemanager"
      "$mod, T, exec, $term"
      "$mod, A, exec, ~/.config/rofi/launchers/type-6/launcher.sh"
      "$mod, P, exec, hyprshot -m region --clipboard-only --freeze"
      #________Window Managment Keybinds________#
      "$mod, W, togglefloating,"
      "$mod, G, togglegroup,"
      "Alt, Return, fullscreen,"
      "$mod, Q, killactive,"
      "$mod, M, exec, pypr layout_center toggle"
      "$mod, left, exec, pypr layout_center prev"
      "$mod, right, exec, pypr layout_center next"
      "$mod, up, exec, pypr layout_center prev2"
      "$mod, down, exec, pypr layout_center next2"

      # Move/Resize focused window

      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizeactive"

      #________Workspace Keybinds________#




      ] ++
      (
       #________Workspace Keybinds________#
      builtins.concatLists (builtins.genList (i:
       let ws = i + 1;
       in [
       "$mod, code:i${toString i}, split:workspace, ${toString ws}"
       "$mod SHIFT,code:i${toString i}, split:workspace, ${toString ws}"
       "$mod+Alt, S, movetoworkspacesilent, special"
       "$mod, S, togglespecialworkspace,"
       ]
      )
      9)
      );



  };
}
