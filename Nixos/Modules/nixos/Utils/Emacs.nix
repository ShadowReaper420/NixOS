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

  

  environment.systemPackages = with pkgs; [
    #libtool
    #libvterm
    emacsPackages.vterm
    nodejs_25
    rust-analyzer
  ];

  programs.direnv = {
    enable = true;
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
