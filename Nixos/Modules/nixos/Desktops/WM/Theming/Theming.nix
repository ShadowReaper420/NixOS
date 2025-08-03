{config, lib, userSettings, systemSettings, inputs, pkgs, ...}: {


    stylix = {
    enable = true;
   # image = ../.dotfiles/Wallpapers/Kath.png; # ignore this it wont actually be used for anything but the option is require for the time being
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    autoEnable = false;

    };

  home-manager.users.${userSettings.username} = {


    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style = {
         name = "kvantum";
         package = pkgs.catppuccin-kvantum.override {
         variant = "mocha";
         accent = "blue";
      };
   };
  };
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
  ];

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
     cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
     };
     iconTheme = {
       package = pkgs.callPackage ./BeautyLine-custom.nix {};
       name = "BeautyLine";
      };
   };

 };
}
