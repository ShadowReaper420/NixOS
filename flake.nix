# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    dankMaterialShell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:AvengeMedia/DankMaterialShell";
    };
    den.url = "github:denful/den";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.55.0";
    hyprland-plugins = {
      inputs.hyprland.follows = "hyprland";
      url = "github:shezdy/hyprsplit";
    };
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

}
