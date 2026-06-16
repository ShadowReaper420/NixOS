{ inputs, self, den, ... }:

{

  den.aspects.WhichKey = {
 

  nixos = { self, nixpkgs, ... }: 
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      mkMenu = menu: let
        configFile = pkgs.writeText "config.yaml"
          (pkgs.lib.generators.toYAML {} {
            anchor = "bottom-right";
            # ...
            inherit menu;
          });
      in
        pkgs.writeShellScriptBin "App-menu" ''
          exec ${pkgs.lib.getExe pkgs.wlr-which-key} ${configFile}
        '';
    in {
      packages.x86_64-linux.default = mkMenu [
        {
          key = "f";
          desc = "Floorp";
          cmd = "floorp";
        }
        {
          key = "e";
          desc = "Dolphin";
          cmd = "dolphin";
        }
        {
          key = "t";
          desc = "Kitty";
          cmd = "kitty";          
        } 
        
      ];
    };
  };
}
