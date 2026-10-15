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

      nixpak = {
        url = "github:nixpak/nixpak";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };
  };
}
