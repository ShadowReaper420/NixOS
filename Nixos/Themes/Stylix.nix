{ config, pkgs, inputs, systemSettings, userSettings, ... }:
{
  stylix = {
    enable = true;
    image = ../.dotfiles/Wallpapers/Kath.png; # ignore this it wont actually be used for anything but the option is require for the time being
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    autoEnable = false;

    };

  home-manager.users.${userSettings.username} = {

     stylix = {
      enable = true;
      #image = ../.dotfiles/Wallpapers/Kath.png; # ignore this it wont actually be used for anything but the option is require for the time being
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      autoEnable = true;
      targets = {
        kitty.enable = true;
        lazygit.enable = true;
        qt.enable = false;
        gtk.enable = true;
        btop.enable = true;
        kde.enable = false;
        emacs.enable = true;
        

     };
   };

    gtk = {
     enable = true;
     iconTheme = {
      package = pkgs.beauty-line-icon-theme;
       name = "BeautyLine";
      };
   };

 };



  
}