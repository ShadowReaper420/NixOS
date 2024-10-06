{config, lib, userSettings.systemSettings. ...}:

{

  #Hyprland config
  wayland.windowMnager.hyprland = {
    enable = true;
    "$mod" = "SUPER";
    "$browser" = userSettings.browser;
    "$term" = userSettings.terminal;
    "$filemanager" = userSettings.fileManager;
    bind =
    [
      #________Application Keybinds________#

      "$mod, F, exec, $browser"
      "$mod, E, exec, $filemanager"
      "$mod, T, exec, $term"
      "$mod, A, exec, rofi -show drun"

      #________Workspace Keybinds________#
      "$mod, 1, split:workspace, 1"
      "$mod, 2, split:workspace, 2"
      "$mod, 3, split:workspace, 3"
      "$mod, 4, split:workspace, 4"
      "$mod, 5, split:workspace, 5"
      "$mod, 6, split:workspace, 6"
      "$mod, 7, split:workspace, 7"
      "$mod, 8, split:workspace, 8"
      "$mod, 9, split:workspace, 9"

      #________Window Managment Keybinds________#
      "$mod, W, togglefloating,"
      "$mod, G, togglegroup,"
      "$mod, Alt, Return, fullscreen"
      "$mod, Q, closewindow,"
      "$mod, Alt, S, movetoworkspacesilent, special"
      "$mod, S, togglespecialworkspace,"
      


    

    ] 
     
    settings = {

      # █░░ ▄▀█ █░█ █▄░█ █▀▀ █░█
      # █▄▄ █▀█ █▄█ █░▀█ █▄▄ █▀█

      "exec-once = waybar"
      "exec-once = mako"
      "exec-once = clipse"
      "exec-once = waypaper"


      #________Animation Settings________#
      "enabled = yes"
      "bexaier = wind, 0.05, 0.9, 0.1, 1.05"
      "bezier = winIn, 0.1, 1.1, 0.1, 1.1"
      "bezier = winOut, 0.3, -0.3, 0, 1"
      "bezier = liner, 1, 1, 1, 1"
      "animation = windows, 1, 6, wind, slide"
      "animation = windowsIn, 1, 6, winIn, slide"
      "animation = windowsOut, 1, 5, winOut, slide"
      "animation = windowsMove, 1, 5, wind, slide"
      "animation = border, 1, 1, liner"
      "animation = borderangle, 1, 30, liner, loop"
      "animation = fade, 1, 10, default"
      "animation = workspaces, 1, 5, wind"


    }
  }



  
}