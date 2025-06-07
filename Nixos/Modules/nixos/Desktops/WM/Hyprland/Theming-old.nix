{config, lib, userSettings, systemSettings, inputs, ...}: {


  home-manager.users.${userSettings.username} = {

    wayland.windowManager.hyprland.settings = {

      layer-rules = [
        "layerrule = blur,rofi"
        "layerrule = ignorezero,rofi"
        "layerrule = blur,notifications"
        "layerrule = ignorezero,notifications"
        "layerrule = blur,swaync-notification-window"
        "layerrule = ignorezero,swaync-notification-window"
        "layerrule = blur,swaync-control-center"
        "layerrule = ignorezero,swaync-control-center"
        "layerrule = blur,logout_dialog"
      ];

      general = {

        gaps_in = 3;
        gaps_out = 8;
        border_size = 2;
        col.active_border = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        col.inactive_border = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        layout = "dwindle";
        resize_on_border = "true";

      };

      group = {
        "col.border_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.border_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg";
       "col.border_locked_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
       "col.border_locked_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg";


      };
      decoration = {
        rounding = 10;
        blur = {
          enabled = "yes";
          size = 6;
          passes = 3;
          new_optimizations = "on";
          ignore_opacity = "on";
          xray = "false";
        };
      };

    };
  };


}
