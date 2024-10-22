{ config, pkgs, inputs, systemSettings, userSettings, ... }:
{
 gtk = {
  enable = true;
  iconTheme = {
    package = pkgs.beauty-line-icon-theme;
    name = "BeautyLine";
  };
 };

   qt = let
    upperFirst = str:
    (lib.toUpper (builtins.substring 0 1 str))
    + (builtins.substring 1 (builtins.stringLength str) str);
    flavorCapitalized = upperFirst config.catppuccin.flavor;
    accentCapitalized = upperFirst config.catppuccin.accent;
  in {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
    kde.settings."Kvantum/kvantum.kvconfig".General.theme = "Catppuccin-${flavorCapitalized}-${accentCapitalized}";
  };

}