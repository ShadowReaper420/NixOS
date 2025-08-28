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
    rofi-wayland
    wl-clipboard
    hyprlock
    cliphist
  ];
  environment.variables = {
    #XCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland";
  };

  systemd.user.services.xdg-desktop-portal = {
    after = [ "xdg-desktop-autostart.target" ];
  };

  systemd.user.services.xdg-desktop-portal-gtk = {
    after = [ "xdg-desktop-autostart.target" ];
  };

  systemd.user.services.xdg-desktop-portal-gnome = {
    after = [ "xdg-desktop-autostart.target" ];
  };

  systemd.user.services.niri-flake-polkit = {
    after = [ "xdg-desktop-autostart.target" ];
  };


  xdg = {
    portal = {
      config.niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
      };
      extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome pkgs.gnome-keyring];
    };
    mime = {
      enable = true;
      addedAssociations = {
        "inode/directory" = [
          "org.kde.dolphin.desktop"
          "thunar.desktop"
        ];
      };
      defaultApplications = {
        "inode/directory" = [
          "org.kde.dolphin.desktop"
          #"thunar.desktop"
        ];
      };

    };

  };



  programs.niri = {
    package = pkgs.niri-unstable;
    enable = true;
  };

  home-manager.users.${userSettings.username} = {
    programs.niri.settings = {
      spawn-at-startup = [
        {
          command = ["swww-daemon"];
        }
        {
          command = ["xwayland-satellite"];
        }
        {
          command = ["quickshell"];
        }
        {
          command = [ "wl-paste --type text --watch cliphist store"];
        }
        {
          command = ["wl-paste --type image --watch cliphist store"];
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
        "Mod+G".action = toggle-column-tabbed-display;
        "Mod+V".action = switch-preset-column-width;

        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+L".action = focus-column-right;

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        #"Mod+S".action.focus-workspace = scratchpad-1;


      };

      gestures.hot-corners.enable = false;

      cursor.theme = "Bibata-Modern-Classic";

      layout = {

        always-center-single-column = true;

        preset-column-widths = [
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
          { proportion = 3. / 3.; }
        ];


        gaps = 6;
        struts.left = 8;
        struts.right = 8;
        border.width = 4;

        border.active.gradient = {
          from = "7fc8ff";
          to = "ffc880";
          in' = "oklch shorter hue";
        };
        border.inactive.gradient = {
          from = "gray";
          to = "ffc880";
          in' = "oklch shorter hue";
        };
      };

      input = {
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "1%";


        };
      };



      prefer-no-csd = true;

      animations = let
        movement-conf = {
          spring = {
            damping-ratio = 0.760000;
            epsilon = 0.000100;
            stiffness = 700;
          };
        };
      in {
        horizontal-view-movement.kind = movement-conf;
        window-movement.kind = movement-conf;
        workspace-switch.kind = movement-conf;
      };
      window-rules = [{
        geometry-corner-radius = {
          bottom-left = 12.0;
          bottom-right = 12.0;
          top-left = 12.0;
          top-right = 12.0;
        };
        clip-to-geometry = true;
      }];
    };
  };
}
