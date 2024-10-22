{config, lib, pkgs, ...}:

{
  fonts.packages = with pkgs; [
    font-awesome
    nerdfonts
  ];
}