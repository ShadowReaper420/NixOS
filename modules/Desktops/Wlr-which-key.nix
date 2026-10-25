{ den, ... }:
{
  den.aspects.which-key = {
    nixos = { config, pkgs, lib, ... }:
    let
      hyprctl = lib.getExe' config.programs.hyprland.package "hyprctl";
      jq = lib.getExe pkgs.jq;
      wwk = lib.getExe pkgs.wlr-which-key;

      # stylix theming shared by both menus
      c = config.lib.stylix.colors;
      fonts = config.stylix.fonts;
      theme = {
        anchor = "center";
        font = "${fonts.monospace.name} ${toString fonts.sizes.popups}";
        background = "#${c.base00}e6";
        color = "#${c.base05}";
        border = "#${c.base0E}";
        border_width = 2;
        corner_r = 10;
        padding = 12;
      };

      mkConfig = name: menu:
        (pkgs.formats.yaml { }).generate "wlr-which-key-${name}.yaml" (theme // { inherit menu; });

      # Toggle special workspace `name`; spawn `run` there if it's empty
      scratchpadScript = name: run:
        assert lib.assertMsg (builtins.match "[A-Za-z0-9_-]+" name != null)
          "scratchpad name must be alphanumeric (got: ${name})";
        pkgs.writeShellScript "scratchpad-${name}" ''
          ${hyprctl} dispatch 'hl.dsp.workspace.toggle_special("${name}")'

          if ! ${hyprctl} clients -j \
               | ${jq} -e --arg ws "special:${name}" 'any(.[]; .workspace.name == $ws)' \
               >/dev/null; then
            setsid -f sh -c ${lib.escapeShellArg run} >/dev/null 2>&1
          fi
        '';

      scratchpad = { key, desc, run, name ? lib.toLower (lib.replaceStrings [ " " ] [ "-" ] desc) }: {
        inherit key desc;
        cmd = "${scratchpadScript name run}";
      };

      app = key: desc: cmd: { inherit key desc cmd; };

      appMenu = [
        (app "f" "Floorp" "floorp")
        (app "e" "Dolphin" "dolphin")
        (app "t" "Kitty" "kitty")
      ];

      scratchMenu = [
        (scratchpad { key = "s"; desc = "Spotify"; run = "spotify"; })
        (scratchpad { key = "d"; desc = "Discord"; run = "discord"; })
        (scratchpad { key = "t"; desc = "Terminal"; run = "kitty"; name = "term"; })
        (scratchpad { key = "k"; desc = "KeepassXC"; run = "Keepassxc"; name = "keepass"; })

      ];

      appMenuBin = pkgs.writeShellScriptBin "App_Menu" ''
        exec ${wwk} ${mkConfig "apps" appMenu}
      '';

      # One key: hide the visible scratchpad, otherwise show the menu
      scratchMenuBin = pkgs.writeShellScriptBin "Scratchpad_Menu" ''
        special=$(${hyprctl} monitors -j \
          | ${jq} -r '.[] | select(.focused) | .specialWorkspace.name')

        if [ -n "$special" ]; then
          ${hyprctl} dispatch "hl.dsp.workspace.toggle_special(\"''${special#special:}\")"
        else
          exec ${wwk} ${mkConfig "scratchpads" scratchMenu}
        fi
      '';
    in
    {
      environment.systemPackages = [ appMenuBin scratchMenuBin ];
    };
  };
}
