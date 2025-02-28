{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
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
}