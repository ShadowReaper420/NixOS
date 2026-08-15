{den, inputs, ...}:
{


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

  den.aspects.hyprland = {lib, ...}: {

    includes = with den.aspects; [
      kanshi
      dolphin
      stylix
      sddm
    ];


    #imports = [
      # inputs.dms.nixosModules.dank-material-shell
      #];


      nixos = {pkgs, inputs', ...}: {

        environment.systemPackages = 
        (with pkgs; [
          rofi
          kitty
          wayland-utils
          awww
          rofi
          wl-clipboard
          linux-wallpaperengine
        ]);

        #programs.dank-material-shell.enable = true;

        programs.hyprland = {
          enable = true;
          xwayland.enable = true;
          package = inputs.hyprland.packages.${pkgs.system}.hyprland;
          portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

        }; 
      };

      home-manager = {config, ...}: {

        home.file."${config.xdg.configHome}" = {
          source = ./.dotfiles;
          recursive = true;
        };

      };

  };
}
