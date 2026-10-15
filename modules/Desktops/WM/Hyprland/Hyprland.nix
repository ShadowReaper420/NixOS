{den, inputs, ...}:
{


  flake-file = {

    inputs = {

      hyprland = {
        url = "github:hyprwm/Hyprland";   
      };

      hyprland-plugins = {
        url = "github:shezdy/hyprsplit";
        inputs.hyprland.follows = "hyprland";
      };

      dankMaterialShell = {
        url = "github:AvengeMedia/DankMaterialShell";
        inputs.nixpkgs.follows = "nixpkgs"; 
      };

      split-monitor-workspaces = {
        url = "github:zjeffer/split-monitor-workspaces?ref=release/0.55.x";
        flake = false;
      };

    };

  };

  den.aspects.hyprland = {

    includes = with den.aspects; [
      dolphin
      stylix
      sddm
      which-key
      rofi

    ];


    imports = [
      #inputs.dms.nixosModules.dank-material-shell
    ];


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
        package = inputs.hyprland.packages.${pkgs.stdenv.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.system}.xdg-desktop-portal-hyprland;

      }; 
    };

    homeManager = { config, pkgs, lib, ... }:
    let
      lua = lib.generators.mkLuaInline;

      bind     = key: action: { _args = [ key (lua action) ]; };
      bindWith = key: action: opts: { _args = [ key (lua action) opts ]; };
      exec     = cmd: ''hl.dsp.exec_cmd("${cmd}")'';

      dirs = [ "left" "right" "up" "down" ];

      luaPlugins = pkgs.linkFarm "hypr-lua-plugins" [
        { name = "split-monitor-workspaces"; path = inputs.split-monitor-workspaces; }
      ];
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";


        package = null;
        portalPackage = null;

        settings = {
          env = [
            { _args = [ "XCURSOR_SIZE" "24" ]; }
            { _args = [ "HYPRCURSOR_SIZE" "24" ]; }
          ];

          config = {
            general = {
              gaps_in = 5;
              gaps_out = 20;
              border_size = 2;
              col = {
                active_border = {
                  colors = lua ''{ "rgba(33ccffee)", "rgba(00ff99ee)" }'';
                  angle = 45;
                };
                inactive_border = "rgba(595959aa)";
              };
              resize_on_border = false;
              allow_tearing = false;
              # Your binds use scrolling-layout commands (colresize/consume/expel),
              # so you probably want "scrolling" here. Kept as in your original.
              layout = "scrolling";
            };

            decoration = {
              rounding = 10;
              rounding_power = 2;
              active_opacity = 1.0;
              inactive_opacity = 1.0;
              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
                color = lua "0xee1a1a1a";
              };
              blur = {
                enabled = true;
                size = 3;
                passes = 1;
                vibrancy = 0.1696;
              };
            };

            animations.enabled = true;
            dwindle.preserve_split = true;
            master.new_status = "master";
            scrolling.fullscreen_on_one_column = true;

            misc = {
              force_default_wallpaper = -1;
              disable_hyprland_logo = false;
            };

            input = {
              kb_layout = "us";
              follow_mouse = 1;
              sensitivity = 0;
              touchpad.natural_scroll = false;
            };
          };

          on = [
            { _args = [ "hyprland.start" (lua ''
              function()
              hl.exec_cmd("awww-daemon")
              hl.exec_cmd("wl-paste --type text --watch cliphist store")
              hl.exec_cmd("wl-paste --type image --watch cliphist store")
              hl.exec_cmd("noctalia")
              end'') ]; }
          ];


          curve = [
            { _args = [ "wind"   { type = "bezier"; points = lua "{ {0.05, 0.9}, {0.1, 1.05} }"; } ]; }
            { _args = [ "winIn"  { type = "bezier"; points = lua "{ {0.1, 1.1}, {0.1, 1.1} }"; } ]; }
            { _args = [ "winOut" { type = "bezier"; points = lua "{ {0.3, -0.3}, {0, 1} }"; } ]; }
            { _args = [ "liner"  { type = "bezier"; points = lua "{ {1, 1}, {1, 1} }"; } ]; }
          ];

          animation = [
            { leaf = "windows";     enabled = true; speed = 6;  bezier = "wind";    style = "slide"; }
            { leaf = "windowsIn";   enabled = true; speed = 6;  bezier = "winIn";   style = "slide"; }
            { leaf = "windowsOut";  enabled = true; speed = 5;  bezier = "winOut";  style = "slide"; }
            { leaf = "windowsMove"; enabled = true; speed = 5;  bezier = "wind";    style = "slide"; }
            { leaf = "border";      enabled = true; speed = 1;  bezier = "liner"; }
            { leaf = "borderangle"; enabled = true; speed = 30; bezier = "liner";   style = "once"; }
            { leaf = "fade";        enabled = true; speed = 10; bezier = "default"; }
            { leaf = "workspaces";  enabled = true; speed = 5;  bezier = "wind"; }
          ];

          bind = [
            (bind "SUPER + T"          ''hl.dsp.exec_cmd("kitty")'')
            (bind "SUPER + F"          ''hl.dsp.exec_cmd("floorp")'')
            (bind "SUPER + E"          ''hl.dsp.exec_cmd("dolphin")'')
            (bind "SUPER + A"          ''hl.dsp.exec_cmd("rofi -show drun")'')
            (bind "SUPER + SHIFT + A"  ''hl.dsp.exec_cmd("App_Menu")'')
            (bind "SUPER + Q"          "hl.dsp.window.close()")
            #(bind "SUPER + SHIFT + E"  "hl.dsp.exit()")

            (bind "SUPER + S"          ''hl.dsp.workspace.toggle_special("stash")'')
            (bind "SUPER + SHIFT + S"  ''hl.dsp.window.move({ workspace = "special:stash" })'')

            (bind "SUPER + W"          ''hl.dsp.window.float({ action = "toggle" })'')
            (bind "SUPER + M"          ''hl.dsp.window.fullscreen({ mode = "maximized" })'')
            (bind "ALT + Return"       ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')

            (bindWith "SUPER + mouse:272" "hl.dsp.window.drag()"   { mouse = true; })
            (bindWith "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; })

            (bindWith "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")'' { locked = true; repeating = true; })
            (bindWith "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")''      { locked = true; repeating = true; })
            (bindWith "XF86AudioMute"        ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")''     { locked = true; })
            (bindWith "XF86AudioPlay"        ''hl.dsp.exec_cmd("playerctl play-pause")''                           { locked = true; })
            (bindWith "XF86AudioNext"        ''hl.dsp.exec_cmd("playerctl next")''                                 { locked = true; })
            (bindWith "XF86AudioPrev"        ''hl.dsp.exec_cmd("playerctl previous")''                             { locked = true; })

            # Only meaningful once the custom/scrolling layout is active:
            # (bind "SUPER + period"     ''hl.dsp.layout("consume")'')
            # (bind "SUPER + comma"      ''hl.dsp.layout("expel")'')
          ]
          ++ map (d: bind "SUPER + ${d}"         ''hl.dsp.focus({ direction = "${d}" })'')       dirs
          ++ map (d: bind "SUPER + SHIFT + ${d}" ''hl.dsp.window.move({ direction = "${d}" })'') dirs;

          window_rule = [
            {
              name = "suppress-maximize-events";
              match.class = ".*";
              suppress_event = "maximize";
            }
            {
              name = "fix-xwayland-drags";
              match = {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              };
              no_focus = true;
            }
            {
              name = "move-hyprland-run";
              match.class = "hyprland-run";
              move = "20 monitor_h-120";
              float = true;
            }
          ];
        };

        # Loops can't be expressed in `settings`, so this stays as a Lua module.
        # Home-manager generates the require() for it in hyprland.lua.
        extraLuaFiles."10-workspaces" = ''
          package.path = package.path .. ";${luaPlugins}/?.lua;${luaPlugins}/?/init.lua"
          local smw = require("split-monitor-workspaces")
          smw.setup({ workspace_count = 9 })   -- set to your count

          for i = 1, smw.get_amount_of_workspaces() do
          local key = tostring(i % 10)       -- workspace 10 on key 0
          hl.bind("SUPER + " .. key,           smw.workspace(tostring(i)))
          hl.bind("SUPER + SHIFT + " .. key,   smw.move_to_workspace_silent(tostring(i)))
          end
        '';
      };
    };
  };
}
