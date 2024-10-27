{config, lib, pkgs, userSettings, systemSettings, inputs, ...}:
{
  environment.systemPackages = with pkgs;[
    cargo
    rustc
    nixd
    rust-analyzer
    


  ];

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins = {
      lazygit.enable = true;
      treesitter.enable = true;



      lsp = {
        enable = true;
        servers = {

          # javascript / typescript
          tsserver.enable = true;

          # lua
          lua-ls.enable = true;

          # rust
          rust-analyzer.enable = true;

          nixd.enable = true;
        };
      };
    };
  };
}