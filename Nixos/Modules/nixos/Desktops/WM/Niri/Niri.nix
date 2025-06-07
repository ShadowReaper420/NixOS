{
  config,
  self,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  niri,
  inputs,
  ...
}: {
 # environment.variables.NIXOS_OZONE_WL = "1"; Breaks discord and other x11 apps just keep it commented out for now.
  environment.systemPackages = with pkgs; [
    wayland-utils
    xwayland-satellite
    cage
    gamescope
    swww
    waypaper
    waybar
  ];

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome pkgs.gnome-keyring];

  programs.niri = {
    package = pkgs.niri-unstable;
    enable = true;
  };

  home-manager.users.${userSettings.username} = {
    programs.niri.settings = {
      spawn-at-startup = [
        {
          command = ["waybar"];
        }
        {
          command = ["waypaper-engine daemon"];
        }
        {
          command = ["xwayland-satellite"];
        }
        {
          command = ["mako"];
        }
        {
          command = ["clipse"];
        }
      ];

      environment = {
        DISPLAY = ":1"; # xwayland-satellite
      };

      binds = with config.home-manager.users.${userSettings.username}.lib.niri.actions; {
        #_________Aplication Keybinds_________#
        "Mod+T".action = spawn userSettings.terminal;
        "Mod+E".action = spawn userSettings.fileManager;
        "Mod+F".action = spawn userSettings.browser;
        "Mod+A".action = spawn "~/.config/rofi/launchers/type-6/launcher.sh";
        "Mod+P".action = screenshot;
        #___________Window Keybinds___________#
        "Mod+Q".action = close-window;
        "Alt+Return".action = fullscreen-window;
        "Mod+W".action = toggle-window-floating;
        #"Mod+Shift+W".action = toggle-window-tile;
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+Plus".action = set-column-width "+10";
        "Mod+Minus".action = set-column-width "-10";
        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-or-workspace-down;
        "Mod+Up".action = focus-window-or-workspace-up;
        "Mod+Right".action = focus-column-right;
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+M".action = maximize-column;
        "Mod+C".action = center-column;
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

      };

      layout = {
        gaps = 8;
        struts.left = 16;
        struts.right = 16;
        border.width = 4;

        border.active.gradient = {
          from = "red";
          to = "blue";
          in' = "oklch shorter hue";
        };
        border.inactive.gradient = {
          from = "gray";
          to = "blue";
          in' = "oklch shorter hue";
        };
      };

      input = {
        #focus-follows-mouse.enable = true;
      };

      animations = let
        movement-conf = {
          spring = {
            damping-ratio = 0.760000;
            epsilon = 0.000100;
            stiffness = 700;
          };
        };
      in {
        horizontal-view-movement = movement-conf;
        window-movement = movement-conf;
        workspace-switch = movement-conf;
      };

      # geometry-corner-radius = {
      # bottom-left = 12.0;
      # bottom-right = 12.0;
      #  top-left = 12.0;
      # top-right = 12.0;
      #};
    };
  };
}
