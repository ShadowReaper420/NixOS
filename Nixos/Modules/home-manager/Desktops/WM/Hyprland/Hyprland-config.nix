{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:

{


  #Hyprland config
  wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    enable = true;
    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".hyprsplit
    ];
     settings = {
    "$mod" = "SUPER";
    "$browser" = userSettings.browser;
    "$term" = userSettings.terminal;
    "$filemanager" = userSettings.fileManager;

     };
     extraConfig = ''
    
    
    # █░░ ▄▀█ █░█ █▄░█ █▀▀ █░█
    # █▄▄ █▀█ █▄█ █░▀█ █▄▄ █▀█
     
      exec-once = waybar
      exec-once = mako
      exec-once = clipse
      exec-once = waypaper-engine daemon
      exec-once = hyprpm reload



      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = _GLX_VENDOR_LIBRARY_NAME,nvidia
      env = PATH,$PATH:$scrPath
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = QT_QPA_PLATFORM,wayland;xcb
      env = QT_QPA_PLATFORMTHEME,qt6ct
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = MOZ_ENABLE_WAYLAND,1
      env = GDK_SCALE,1

      monitor=DP-5, 2560x1440, 0x0, 1
      monitor=HDMI-A-2, 2560x1440, -1440x0, 1

      cursor {
        no_hardware_cursors = true
      
       }

      dwindle {
         pseudotile = yes
         
      
      }


 

      animations {
       enabled = yes
       bezier = wind, 0.05, 0.9, 0.1, 1.05
       bezier = winIn, 0.1, 1.1, 0.1, 1.1
       bezier = winOut, 0.3, -0.3, 0, 1
       bezier = liner, 1, 1, 1, 1
       animation = workspaces, 1, 5, wind
       animation = windowsIn, 1, 6, winIn, slide
       animation = windowsOut, 1, 5, winOut, slide
       animation = windowsMove, 1, 5, wind, slide
       animation = border, 1, 1, liner
       animation = borderangle, 1, 30, liner, loop
       animation = fade, 1, 10, default
       animation = workspaces, 1, 5, wind
     }


  #________Application Keybinds________#

     bind = $mod, F, exec, $browser
     bind = $mod, E, exec, $filemanager
     bind = $mod, T, exec, $term
     bind = $mod, A, exec, rofi -show drun
     bind = $mod, P, exec, hyprshot -m region

 #________Window Managment Keybinds________#
     bind = $mod, W, togglefloating,
     bind = $mod, G, togglegroup,"
    # bind = $mod, Alt, Return, fullscreen,
     bind = $mod, Q, killactive,

     # Move/Resize focused window

     bindm = $mod, mouse:272, movewindow
     bindm = $mod, mouse:273, resizeactive
      
      
  #________Workspace Keybinds________#

     bind = $mod, 1, split:workspace, 1
     bind = $mod, 2, split:workspace, 2
     bind = $mod, 3, split:workspace, 3
     bind = $mod, 4, split:workspace, 4
     bind = $mod, 5, split:workspace, 5
     bind = $mod, 6, split:workspace, 6
     bind = $mod, 7, split:workspace, 7
     bind = $mod, 8, split:workspace, 8
     bind = $mod, 9, split:workspace, 9
     bind = $mod, 0, split:workspace, 10
     bind = $mod+Alt, S, movetoworkspacesilent, special
     bind = $mod, S, togglespecialworkspace,
     
# █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
# ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

# See https://wiki.hyprland.org/Configuring/Window-Rules/

#indowrulev2 = opacity 0.90 0.90,class:^(floorp)$
windowrulev2 = opacity 0.90 0.90,class:^(Brave-browser)$
#windowrulev2 = opacity 0.80 0.80,class:^(code-oss)$
windowrulev2 = opacity 0.80 0.80,class:^(Code)$
windowrulev2 = opacity 0.80 0.80,class:^(vscodium)$
windowrulev2 = opacity 0.80 0.80,class:^(code-url-handler)$
windowrulev2 = opacity 0.80 0.80,class:^(code-insiders-url-handler)$
windowrulev2 = opacity 0.70 0.70,class:^(kitty)$
windowrulev2 = opacity 0.80 0.80,class:^(org.kde.dolphin)$
windowrulev2 = opacity 0.80 0.80,class:^(org.kde.ark)$
windowrulev2 = opacity 0.80 0.80,class:^(nwg-look)$
windowrulev2 = opacity 0.80 0.80,class:^(qt5ct)$
windowrulev2 = opacity 0.80 0.80,class:^(qt6ct)$
windowrulev2 = opacity 0.80 0.80,class:^(kvantummanager)$
windowrulev2 = opacity 0.80 0.70,class:^(pavucontrol)$
windowrulev2 = opacity 0.80 0.70,class:^(blueman-manager)$
windowrulev2 = opacity 0.80 0.70,class:^(nm-applet)$
windowrulev2 = opacity 0.80 0.70,class:^(nm-connection-editor)$
windowrulev2 = opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$
windowrulev2 = opacity 0.80 0.70,class:^(polkit-gnome-authentication-agent-1)$
windowrulev2 = opacity 0.80 0.70,class:^(org.freedesktop.impl.portal.desktop.gtk)$
windowrulev2 = opacity 0.80 0.70,class:^(org.freedesktop.impl.portal.desktop.hyprland)$
windowrulev2 = opacity 0.70 0.70,class:^([Ss]team)$
windowrulev2 = opacity 0.70 0.70,class:^(steamwebhelper)$
windowrulev2 = opacity 0.70 0.70,class:^(Spotify)$
windowrulev2 = opacity 0.70 0.70,initialTitle:^(Spotify Free)$
windowrulev2 = opacity 0.70 0.70,class:^(Vesktop)$

windowrulev2 = opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$ # Cartridges-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(com.obsproject.Studio)$ # Obs-Qt
windowrulev2 = opacity 0.80 0.80,class:^(gnome-boxes)$ # Boxes-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(discord)$ # Discord-Electron
windowrulev2 = opacity 0.80 0.80,class:^(WebCord)$ # WebCord-Electron
windowrulev2 = opacity 0.80 0.80,class:^(ArmCord)$ # ArmCord-Electron
windowrulev2 = opacity 0.80 0.80,class:^(app.drey.Warp)$ # Warp-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrulev2 = opacity 0.80 0.80,class:^(yad)$ # Protontricks-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(Signal)$ # Signal-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(io.github.alainm23.planify)$ # planify-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk
windowrulev2 = opacity 0.80 0.80,class:^(io.github.flattool.Warehouse)$ # Warehouse-Gtk

windowrulev2 = float,class:^(org.kde.dolphin)$,title:^(Progress Dialog — Dolphin)$
windowrulev2 = float,class:^(org.kde.dolphin)$,title:^(Copying — Dolphin)$
windowrulev2 = float,class:^(firefox)$,title:^(Picture-in-Picture)$
windowrulev2 = float,class:^(firefox)$,title:^(Library)$
windowrulev2 = float,class:^(kitty)$,title:^(top)$
windowrulev2 = float,class:^(kitty)$,title:^(btop)$
windowrulev2 = float,class:^(kitty)$,title:^(htop)$
windowrulev2 = float,class:^(vlc)$
windowrulev2 = float,class:^(kvantummanager)$
windowrulev2 = float,class:^(qt5ct)$
windowrulev2 = float,class:^(qt6ct)$
windowrulev2 = float,class:^(nwg-look)$
windowrulev2 = float,class:^(org.kde.ark)$
windowrulev2 = float,class:^(pavucontrol)$
windowrulev2 = float,class:^(blueman-manager)$
windowrulev2 = float,class:^(nm-applet)$
windowrulev2 = float,class:^(nm-connection-editor)$
windowrulev2 = float,class:^(org.kde.polkit-kde-authentication-agent-1)$

windowrulev2 = float,class:^(Signal)$ # Signal-Gtk
windowrulev2 = float,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk
windowrulev2 = float,class:^(app.drey.Warp)$ # Warp-Gtk
windowrulev2 = float,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt
windowrulev2 = float,class:^(yad)$ # Protontricks-Gtk
windowrulev2 = float,class:^(eog)$ # Imageviewer-Gtk
windowrulev2 = float,class:^(io.github.alainm23.planify)$ # planify-Gtk
windowrulev2 = float,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk
windowrulev2 = float,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk
windowrulev2 = float,class:^(io.gitlab.adhami3310.Impression)$ # Impression-Gtk
windowrulev2 = float,class:^(io.missioncenter.MissionCenter)$ # MissionCenter-Gtk


# █░░ ▄▀█ █▄█ █▀▀ █▀█   █▀█ █░█ █░░ █▀▀ █▀
# █▄▄ █▀█ ░█░ ██▄ █▀▄   █▀▄ █▄█ █▄▄ ██▄ ▄█

layerrule = blur,rofi
layerrule = ignorezero,rofi
layerrule = blur,notifications
layerrule = ignorezero,notifications
layerrule = blur,swaync-notification-window
layerrule = ignorezero,swaync-notification-window
layerrule = blur,swaync-control-center
layerrule = ignorezero,swaync-control-center
layerrule = blur,logout_dialog



general {
    gaps_in = 3
    gaps_out = 8
    border_size = 2
    col.active_border = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
    col.inactive_border = rgba(b4befecc) rgba(6c7086cc) 45deg
    layout = dwindle
    resize_on_border = true
}

group {
    col.border_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
    col.border_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
    col.border_locked_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
    col.border_locked_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
}

decoration {
    rounding = 10
    drop_shadow = false

    blur {
        enabled = yes
        size = 6
        passes = 3
        new_optimizations = on
        ignore_opacity = on
        xray = false
    }
}

layerrule = blur,waybar




    
      

     '';
   };
  }
