{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim.vimAlias = true;

      vim.lsp.enable = true;

      vim.languages = {
        nix = {
          enable = true;
          package = [nixd];
        };

        rust.enable = true;
        lua.enable = true;
        clang.enable = true;
        ts.enable = true;
      };
    };
  };

  config.vim.extraPlugins = with pkgs.vimPlugins; {

    treesitter = {
      package = nvim-treesitter;
      setup = ''
         require('treesitter').setup {
         
         }
         ''
    };
  };
}