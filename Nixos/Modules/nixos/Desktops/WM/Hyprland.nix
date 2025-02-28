{config, self, lib, pkgs, userSettings, systemSettings, inputs, ...}:

{
    programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };
 #home-manager.users.${userSettings.username} = {

 #};
}