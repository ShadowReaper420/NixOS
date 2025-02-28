{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  home.packages = [
  
  (pkgs.writeShellScriptBin "rofi" '' 
  
  dir="$HOME/.config/rofi/launchers/type-6"
  theme='style-2'
  ## Run
  rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi 
    '')
  ];
}
