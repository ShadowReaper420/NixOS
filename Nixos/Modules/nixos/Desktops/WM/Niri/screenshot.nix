{ config, lib, pkgs, userSettings, ... }:

{
    home-manager.users.${userSettings.username} = {
      programs.niri.settings = {
        binds = {
          "Mod+P".action.screenshot = true;
        };
      };
    };

}
