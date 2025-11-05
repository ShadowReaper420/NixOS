{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  userSettings,
  systemSettings,
  inputs,
  ...
}: {

  services.emacs = {
    enable = true;
    package = pkgs-unstable.emacs;

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
