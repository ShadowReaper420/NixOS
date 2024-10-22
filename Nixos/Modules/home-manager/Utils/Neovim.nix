{
  programs.nvf = {
    enable = true;

    settings = {
      vim.lsp = {
        enable = true;
      };
    };
  };
  config.vim.extraPlugins = with pkgs.vimPlugins; {
    
  }
}