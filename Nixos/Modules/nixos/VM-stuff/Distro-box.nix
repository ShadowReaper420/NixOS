{config, lib, pkgs, userSettings, systemSettings, ...}:
{
 # virtualisation.podman = {
  #enable = true;
 #};

  virtualisation.docker = {
   enable = true;
  };

environment.systemPackages = [ pkgs.distrobox pkgs.boxbuddy ];


}
