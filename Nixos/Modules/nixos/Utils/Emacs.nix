{
  config,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  inputs,
  ...
}: {

  services.emacs = {
    enable = true;
    package = pkgs.emacs;

  };
  home-manager.users.${userSettings.username} = {
  #  xdg.desktopEntries = {
   #   Doom = {
     #   name = "Doom";
     #   genericName = "Emacs";
     #   exec = "emacsclient -c -a 'emacs'";
     #   categories = ["Application"];
     # };
    #};
  };
}
