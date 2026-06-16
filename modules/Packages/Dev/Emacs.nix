{ inputs, pkgs, self, den, ... }:
{
  den.aspects.emacs = {
    nixos = {

      services.emacs = {
        enable = true;
        package = pkgs.emacs;
        
      };
      
      environment.systemPackages = with pkgs; [
        #libtool
        #libvterm
        emacsPackages.vterm
        nodejs_25
        nixd
        nodejs
        #python315
        #nil
        cmake
        clang
        #rust-analyzer
        #rustc 
        #python313Packages.python-lsp-server
        emacs
        ripgrep
        #cargo
        alejandra
        docker-compose
        godot
        lua-language-server
        ispell
        fd
        gvfs
        rust-analyzer
      ]; 

      programs.direnv = {
        enable = true;
      };


    };

  };
}
