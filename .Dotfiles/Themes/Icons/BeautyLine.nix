{config, lib, pkgs, ...}:

{
  environment.systemPackages = [
    pkgs.beauty-line-icon-theme
  ];
}