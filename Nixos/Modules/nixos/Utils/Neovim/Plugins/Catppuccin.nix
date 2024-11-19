{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
    };
  
  };
}