{ config, lib, pkgs, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        lsp = {
        enable = true;
      };
      };
    };
  };
}
