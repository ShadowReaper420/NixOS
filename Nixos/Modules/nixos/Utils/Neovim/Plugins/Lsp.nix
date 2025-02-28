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
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };

          #lua
          lua_ls.enable = true;

          #nix
          nixd.enable = true;

        };
      };
    };
  };
}