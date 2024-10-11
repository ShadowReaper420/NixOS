# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
{lib, config, pkgs, ...}:
{
   imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
     # ./Desktops/WM/Wayfire/Wayfire.nix
      ./Home/Misc.nix
      ./Desktops/WM/Wayland-Utils/Wayland-utils.nix
      ./Utils/Utils.nix
      #./Desktops/WM/Desktop-Control.nix
      ./Desktops/WM/Hyprland/Hyprland-config.nix
      ./CLI-Collection/CLI-Crap.nix
      #./stylix.nix

      ];
}
