{config, self, lib, pkgs, userSettings, systemSettings, inputs, ...}:

{
    programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };

  };
    home-manager.users.${userSettings.username} = {

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