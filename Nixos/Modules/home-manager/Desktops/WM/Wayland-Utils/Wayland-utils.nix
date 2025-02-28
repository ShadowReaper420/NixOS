 {config, lib, pkgs, ...}:

  {
 #   programs.rofi = {
 #     theme = ../Wayland

   # };



 home.packages = with pkgs; [
 rofi-wayland
 #waypaper
 #swww
 mako
 wlogout
 waybar
 swaylock
 clipse
 wlsunset
 hyprshot
 ags
 #swaynotificationcenter
 pavucontrol


 ];
  }
