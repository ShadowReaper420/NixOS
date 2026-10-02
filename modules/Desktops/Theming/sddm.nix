{ inputs, self, ... }:
{
  den.aspects.sddm = {

    nixos = {pkgs, ...}:
    let
      sddm-astronaut = pkgs.sddm-astronaut.override { embeddedTheme = "black_hole";};
    in
    {

      services.displayManager.sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;

        theme = "sddm-astronaut-theme";
        extraPackages = [ sddm-astronaut ];
        CursorTheme = "Bibata-Modern-Classic";
        CursorSize = 24;

        wayland.enable = true;
      };

      environment.systemPackages = [ sddm-astronaut ];
    };

  };
}
