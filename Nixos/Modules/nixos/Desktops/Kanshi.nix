{ config, lib, pkgs, userSettings, ... }:

with lib;
let
  cfg = config.modules.desktops-tools.kanshi;

in
{
  options.modules.desktops-tools.kanshi = {
    enable = lib.mkEnableOption "Kanshi Settings";
  };

  config = mkIf cfg.enable  {
    home-manager.users.${userSettings.username} = {
      services.kanshi = {
        enable = true;

        profiles = {
          home = {
            outputs = [
              {
                criteria = "DP-2";
                position = "0,0";
                mode = "2560x1440@144Hz";
                scale = 1.0;
              }
              {
                criteria = "HDMI-A-1";
                position = "2560,0";
                mode = "1920x1080@60Hz";
                scale = 1.0;
              }
            ];
          };
        };
      };
    };
  };
}

