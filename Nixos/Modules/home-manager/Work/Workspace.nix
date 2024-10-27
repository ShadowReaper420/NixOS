{config, lib, pkgs, ...}:
{
  home.packages = with pkgs; [
    libreoffice
    obs-studio

  ];
}