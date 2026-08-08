{ inputs, pkgs, config, ... }:
{
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  # other inputs may be defined at a module using them.
  flake-file = {

    inputs = {
      nixpkgs-stable.url = "nixpkgs/nixos-25.11";
      nixpkgs.url = "nixpkgs/nixos-unstable";

      den.url = "github:denful/den";
      flake-file.url = "github:vic/flake-file";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

   


    # pkgs-stable = import inputs.nixpkgs-stable {
    #   system = pkgs.stdenv.hostPlatform.system;
    #   config.allowUnfree = true;

    # };
     # pkgs = import inputs.nixpkgs {
     #   system = pkgs.stdenv.hostPlatform.system;
     #   config.allowUnfree = true;
     #   config.permittedInsecurePackages = [
     #     "nexusmods-app-unfree-0.21.1"
     #     #"openclaw-2026.4.21"
     #   ];
       
    #   overlays = [
    #     #inputs.niri.overlays.niri
    #   ];
    # };


  };
}
