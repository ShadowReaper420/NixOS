{
  config,
  self,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  inputs,
  ...
}: {

  #  services.displayManager.sddm = {
    #   extraPackages = [ sddm-astronaut ];
    #   enable = true;
    # wayland.enable = true;
    # theme = "sddm-astronaut-theme";
    #theme = "${import ../../SDDM.nix { inherit pkgs; }}";
    #;


    environment.systemPackages = with pkgs; [
      # (callPackage ../../SDDM.nix {}).Candy-sddm-theme
    ];

    imports = [
      ../../sddm-theme.nix

    ];


    programs.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    home-manager.users.${userSettings.username} = {
      lib.mkForce.services.hyprpaper.enable = false;

      wayland.windowManager.hyprland = {
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        enable = true;
        plugins = [
          inputs.hyprland-plugins.packages."${pkgs.system}".hyprsplit
        ];
      };

      imports = [
        # ./Animations.nix
        # ./Keybinds.nix
        # ./Theming.nix
        # ./Window-rules.nix

      ];

      home.packages = with pkgs; [
        rofi-wayland
        swww
        mako
        wlogout
        waybar
        swaylock
        clipse
        wlsunset
        hyprshot
        ags
        pavucontrol
        grimblast
        waypaper
        linux-wallpaperengine
        gvfs
        wl-clipboard
        wireplumber
        hyprpanel
      ];

      home.pointerCursor = {
        gtk.enable = true;
        # x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };
    };
}
