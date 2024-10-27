{config, lib, pkgs, userSettings, systemSettings, ...}:
{
  virtualisation.podman = {
  enable = true;
  dockerCompat = true;
};

environment.systemPackages = [ pkgs.distrobox pkgs.boxbuddy ];


}