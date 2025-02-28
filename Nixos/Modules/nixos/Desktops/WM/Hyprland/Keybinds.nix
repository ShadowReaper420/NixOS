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
      "$mod, A, exec, rofi -show drun"
      "$mod, P, exec, hyprshot -m region --clipboard-only --freeze"
      

    ];

    



  };
}