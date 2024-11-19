{
  programs.nixvim = {
    
    plugins = {
      nvim-cmp = {
        enable = true;
        autoEnableSources = true;

      };
      lsp = {
        enable = true;
        servers = {

          #rust
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };

          #lua
          lua-ls.enable = true;

          #nix
          nixd.enable = true;

        };
      };
    };
  };
}