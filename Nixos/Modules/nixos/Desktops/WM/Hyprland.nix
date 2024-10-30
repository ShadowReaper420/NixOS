{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:

{
    programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

}