# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
{ config, pkgs, inputs, systemSettings, userSettings, ... }:
{
   imports = [

    # You can also split up your configuration and import pieces of it here:
      #./Work/Workspace.nix
      #./Desktops/WM/Desktop-Control.nix
      ./Desktops/WM/Hyprland/Hyprland-config.nix
      ./CLI-Collection/CLI-Crap.nix
     # ./stylix.nix
      ./Themes/QT.nix

      ];
}
