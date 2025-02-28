{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  programs.nixvim = {
    enable = true;
    colorscemes = {
      catppuccin = {
        enable = true;
      };
    };
  };
}