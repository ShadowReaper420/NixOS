{ config, pkgs, inputs, systemSettings, userSettings, ... }:
{
  stylix = {
    enable = true;
    image = ../.dotfiles/Wallpapers/Kath.png; # ignore this it wont actually be used for anything but the option is require for the time being
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    autoEnable = false;

    };



  
}