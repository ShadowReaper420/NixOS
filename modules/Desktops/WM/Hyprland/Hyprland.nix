

{
  den.aspects.hyprland = {inputs, lib, ...}: {

    flake-file = {

      inputs = {

        hyprland = {
          url = "github:hyprwm/Hyprland/v0.55.0";   
        };

        hyprland-plugins = {
          url = "github:shezdy/hyprsplit";
          inputs.hyprland.follows = "hyprland";
        };

        dankMaterialShell = {
          url = "github:AvengeMedia/DankMaterialShell";
          inputs.nixpkgs.follows = "nixpkgs"; 
        };

      };


    };

    imports = [
      inputs.dms.nixosModules.dank-material-shell
    ];


    nixos = {pkgs, inputs, ...}: {

      environment.systemPackages = 
      (with pkgs; [
        rofi
        wayland-utils
        awww
        rofi
        wl-clipboard
        linux-wallpaperengine
      ]);

      porgrams.dank-material-shell.enable = true;

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

      }; 


    };

  };
}
