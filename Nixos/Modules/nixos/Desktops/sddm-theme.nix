{ pkgs, ... }:
let
sddm-astronaut = pkgs.sddm-astronaut.override { embeddedTheme = "hyprland_kath";};

in {
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;

    theme = "sddm-astronaut-theme";
    extraPackages = [ sddm-astronaut ];

#    wayland.enable = true;
  };

  environment.systemPackages = [ sddm-astronaut ];
}
