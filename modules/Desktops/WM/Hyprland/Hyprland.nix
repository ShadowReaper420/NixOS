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
        url = "github:zjeffer/split-monitor-workspaces";
        flake = false;
      };

      noctalia = {
        url = "github:noctalia-dev/noctalia-shell";
        #inputs.nixpkgs.follows = "nixpkgs";
      };


    };

  };

  den.aspects.hyprland = {

    includes = with den.aspects; [
      dolphin
      stylix
      sddm
      which-key
      #keepassxc
      #rofi

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
        kdePackages.kwallet
        hyprshot
        linux-wallpaperengine
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        hyprpolkitagent

      ]);

      #programs.dank-material-shell.enable = true;

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.system}.xdg-desktop-portal-hyprland;

      };

      security.polkit.enable = true;






      xdg.mime = {
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
          "text/html" = "floorp.desktop";
          "x-scheme-handler/http" = "floorp.desktop";
          "x-scheme-handler/https" = "floorp.desktop";
          "x-scheme-handler/about" = "floorp.desktop";
          "x-scheme-handler/unknown" = "floorp.desktop";
        };

      };

      environment.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_STYLE_OVERRIDE = "kvantum";
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


      c = config.lib.stylix.colors;   # base16 palette, hex without "#

      gradient = a: b: alpha:
      lua ''{ colors = { "rgba(${c.${a}}${alpha})", "rgba(${c.${b}}${alpha})" }, angle = 45 }'';

      active   = gradient "base0E" "base06" "ff";
      inactive = gradient "base07" "base04" "cc";

      lbind = key: { scrolling ? null, scrollcols ? null, other ? null }:
      bind key (
        "layout_bind({ "
        + lib.optionalString (scrolling != null)  "scrolling = ${scrolling}, "
        + lib.optionalString (scrollcols != null) "scrollcols = ${scrollcols}, "
        + lib.optionalString (other != null)      "other = ${other}, "
        + "})"
      );

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
            { _args = [ "HYPRCURSOR_SIZE" "24" ];}
            # { _args = ["QT_QPA_PLATFORMTHEME" "qt6ct"]; }
          ];

          monitor = [
            {
              output = "DP-2";
              bitdepth = 10;
            }
          ];


          config = {
            general = {
              gaps_in = 5;
              gaps_out = 10;
              border_size = 4;
              resize_on_border = true;
              col = {
                active_border   = active;
                inactive_border = inactive;
              };

              allow_tearing = false;
              layout = "scrolling";
            };

            group.col = {
              border_active          = active;
              border_inactive        = inactive;
              border_locked_active   = active;
              border_locked_inactive = inactive;
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
            scrolling = {

              fullscreen_on_one_column = true;
              column_width = 0.5;
              explicit_column_widths = "0.5, 0.667, 1.0";
              follow_focus = false;

            };

            misc = {
              force_default_wallpaper = -1;
              disable_hyprland_logo = false;
              enable_anr_dialog = false;
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
              hl.exec_cmd("spotify")
              hl.exec_cmd("discord")
              hl.exec_cmd("kitty --class scratch-term")
              hl.exec_cmd("systemctl --user start hyprpolkitagent")
              end

            '' )]; }

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
            { leaf = "workspaces";  enabled = true; speed = 6;  bezier = "wind";    style = "slidevert";}
          ];


          bind = [

            (lbind "SUPER + M" {
              scrolling  = ''hl.dsp.layout("colresize 1.0")'';
              scrollcols = ''hl.dsp.layout("width 1")'';
            })
            (lbind "SUPER + V" {
              scrolling  = ''hl.dsp.layout("colresize +conf")'';
              scrollcols = ''hl.dsp.layout("preset next")'';
            })
            (lbind "SUPER + left" {
              scrolling  = ''hl.dsp.layout("focus l")'';
              scrollcols = ''hl.dsp.focus({ direction = "left" })'';
              other      = ''hl.dsp.focus({ direction = "left" })'';
            })
            (lbind "SUPER + right" {
              scrolling  = ''hl.dsp.layout("focus r")'';
              scrollcols = ''hl.dsp.focus({ direction = "right" })'';
              other      = ''hl.dsp.focus({ direction = "right" })'';
            })
            (lbind "SUPER + period" {
              scrolling  = ''hl.dsp.window.move({ direction = "right" })'';
              scrollcols = ''hl.dsp.layout("consume right")'';
            })
            (lbind "SUPER + comma" {
              scrolling  = ''hl.dsp.layout("promote")'';
              scrollcols = ''hl.dsp.layout("expel")'';
            })

            (bind "SUPER + T"          ''hl.dsp.exec_cmd("kitty")'')
            (bind "SUPER + F"          ''hl.dsp.exec_cmd("floorp")'')
            #(bind "SUPER + E"          ''hl.dsp.exec_cmd("dolphin")'')
            (bind "SUPER + A"          ''hl.dsp.exec_cmd("~/.config/rofi/launchers/type-6/launcher.sh")'')
            (bind "SUPER + E"           ''hl.dsp.exec_cmd("App_Menu")'')
            (bind "SUPER + Q"          "hl.dsp.window.close()")
            (bind "SUPER + P"          ''hl.dsp.exec_cmd("hyprshot -m region --clipboard-only")'' )
            (bind "SUPER + SHIFT+ P"   ''hl.dsp.exec_cmd("hypershot -m window --clipboard-only")'' )


            #global keybinds
            #(bind "Control_L" ''hl.dsp.pass({ window = "class:^(discord)$" })'') 

            (bind "SUPER + S" ''hl.dsp.exec_cmd("Scratchpad_Menu")'')
            (bind "SUPER + SHIFT + S"  ''hl.dsp.window.move({ workspace = "special:stash" })'')

            (bind "SUPER + W"          ''hl.dsp.window.float({ action = "toggle" })'')
            #(bind "SUPER + M"          ''hl.dsp.layout("colresize 1.0")'')
            (bind "ALT + Return"       ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')
            #(bind "SUPER + V"          ''hl.dsp.layout("colresize +conf")'')
            #(bind "SUPER + left"       ''hl.dsp.layout("focus l")'')
            #(bind "SUPER + right"      ''hl.dsp.layout("focus r")'')
            #(bind "SUPER + period"     ''hl.dsp.layout("consume")'')
            #(bind "SUPER + comma"      ''hl.dsp.layout("expel")'')


            (bindWith "SUPER + mouse:272" "hl.dsp.window.drag()"   { mouse = true; })
            (bindWith "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; })

            (bindWith "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")'' { locked = true; repeating = true; })
            (bindWith "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")''      { locked = true; repeating = true; })
            (bindWith "XF86AudioMute"        ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")''     { locked = true; })
            (bindWith "XF86AudioPlay"        ''hl.dsp.exec_cmd("playerctl play-pause")''                           { locked = true; })
            (bindWith "XF86AudioNext"        ''hl.dsp.exec_cmd("playerctl next")''                                 { locked = true; })
            (bindWith "XF86AudioPrev"        ''hl.dsp.exec_cmd("playerctl previous")''                             { locked = true; })



          ];

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
            {
              name = "spotify-scratchpad";
              match.class = "(?i)^spotify$";
              workspace = "special:spotify silent";
            }
            {
              # Spotify sets its class late, so also match on the initial class
              name = "spotify-scratchpad-initial";
              match.initial_class = "(?i)^spotify$";
              workspace = "special:spotify silent";
            }
            {
              name = "discord-scratchpad";
              match.class = "(?i)^discord$";
              workspace = "special:discord silent";
            }
            {
              name = "terminal-scratchpad";
              match.class = "^scratch-term$";
              workspace = "special:term silent";
            }
            {
              name = "keepassxc-scratchpad";
              match.class = "(?i)^keepassxc$";
              workspace = "special:keepassxc silent";
            }
            {
              name = "wine-float";
              match = { xwayland = true; class = "\\.exe$"; };
              float = true;
            }
          ];
        };

        # Loops can't be expressed in `settings`, so this stays as a Lua module.
        # Home-manager generates the require() for it in hyprland.lua.
        extraLuaFiles = {


          "10-workspaces" = ''
            package.path = package.path .. ";${luaPlugins}/?.lua;${luaPlugins}/?/init.lua"
            local smw = require("split-monitor-workspaces")
            smw.setup({ workspace_count = 9 })   -- set to your count

            for i = 1, smw.get_amount_of_workspaces() do
            local key = tostring(i % 10)       -- workspace 10 on key 0
            hl.bind("SUPER + " .. key,           smw.workspace(tostring(i)))
            hl.bind("SUPER + SHIFT + " .. key,   smw.move_to_workspace_silent(tostring(i)))
            end
          '';

          "00-layout-bind" = ''
            -- layout_bind{ scrolling = <dispatcher>, scrollcols = <dispatcher>, other = <dispatcher> }
            -- Returns a function that runs the entry matching the active workspace's layout.
            function layout_bind(actions)
            return function()
            local name
            local ok, ws = pcall(hl.get_active_workspace)
            if ok and ws then name = ws.tiled_layout end
            if name == nil then
            local ok2, v = pcall(hl.get_config, "general.layout")
            if ok2 then name = v end
            end
            name = tostring(name or "")

            local action
            if name:find("scrollcols", 1, true) then
            action = actions.scrollcols
            elseif name == "scrolling" then
            action = actions.scrolling
            else
            action = actions.other
            end
            if action then hl.dispatch(action) end
            end
            end
          '';

        };

      };
    };
  };
}
