{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  imports = [
    ./Plugins/Harpoon.nix
    ./Plugins/Catppuccin.nix
    ./Plugins/Lazygit.nix
    ./Plugins/Lualine.nix
    ./Plugins/Treesitter.nix
    ./Plugins/Lsp.nix
    ./Plugins/Nvim-tree.nix

  ];

  programs.nixvim = {
    enable = true;
  };
}