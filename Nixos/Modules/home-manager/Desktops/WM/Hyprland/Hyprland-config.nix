{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:

{


  #Hyprland config
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".hyprsplit
    ];
     settings = {
    "$mod" = "SUPER";
    "$browser" = userSettings.browser;
    "$term" = userSettings.terminal;
    "$filemanager" = userSettings.fileManager;



    animations = [
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
    ];

    bindm =
    [
      #________Application Keybinds________#

      "$mod, F, exec, $browser"
      "$mod, E, exec, $filemanager"
      "$mod, T, exec, $term"
      "$mod, A, exec, rofi -show drun"
      "$mod, P, exec, hyprshot -m region"

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
      "$mod, 0, split:workspace, 10"

      #________Window Managment Keybinds________#
      "$mod, W, togglefloating,"
      "$mod, G, togglegroup,"
      "$mod, Alt, Return, fullscreen"
      "$mod, Q, closewindow,"
      


    

    ];

     };
     extraConfig = ''
    
    
    # █░░ ▄▀█ █░█ █▄░█ █▀▀ █░█
    # █▄▄ █▀█ █▄█ █░▀█ █▄▄ █▀█
     
      exec-once = waybar
      exec-once = mako
      exec-once = clipse
      exec-once = waypaper-engine daemon


      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = _GLX_VENDOR_LIBRARY_NAME,nvidia

      cursor {
        no_hardware_cursors = true
      
       }

      dwindle {
         pseudotile = yes
         perserve_split = yes
      
      }
      

     '';
   };
  }