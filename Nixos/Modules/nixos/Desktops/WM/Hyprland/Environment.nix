{ config, lib, pkgs, userSettings, ... }:

{
  home-manager.users.${userSettings.username} = {
    wayland.windowManager.hyprland.settings = {
      env = [

        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "_GLX_VENDOR_LIBRARY_NAME,nvidia"
        "PATH,$PATH:$scrPath"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_STYLE_OVERRIDE=kvantum"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "MOZ_ENABLE_WAYLAND,1"
        "GDK_SCALE,1"



      ];

      exec-once = [

        # █░░ ▄▀█ █░█ █▄░█ █▀▀ █░█
        # █▄▄ █▀█ █▄█ █░▀█ █▄▄ █▀█

        #exec-once = waybar
        #exec-once = mako
        "hyprpanel"
        "clipse"
        "linux-wallpaperengine --silent --screen-root DP-5 --scaling stretch 1139304621"
        "linux-wallpaperengine --silent --screen-root HDMI-A-2 --scaling  stretch 1126387049"
        "hyprpm reload"
        "pypr"
        #exec-once = mpvpaper '*' /home/flugel/Nixos/.dotfiles/Wallpapers/Galaxy.mp4



      ];

      monitor = [
        "DP-5,2560x1440@60.0,2560x0,1.0"
        "HDMI-A-2,2560x1440@60.0,5120x0,1.0"
      ];

      cursor = [
        "no_hardware_cursors = true"

      ];



    };
  };
}
