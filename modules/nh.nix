# Exposes flake apps under the name of each host / home for building with nh.
{ den, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = den.lib.nh.denPackages { fromFlake = true; } pkgs;
    };
}
        # Nix rebuild helper
        # programs.nh = {
        #   enable = true;
        #   clean.enable = true;
        #   clean.extraArgs = "--keep-since 4d --keep 5";
        #   flake = "/home/flugel/NixOS-Dev/Nixos/";
        # };

