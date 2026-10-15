{ den, ... }:
{
  den.aspects.which-key = {
    nixos = { config, pkgs, lib, ... }:
    let
      # Use the hyprctl from the running Hyprland package so IPC versions match
      hyprctl = lib.getExe' config.programs.hyprland.package "hyprctl";
      jq = lib.getExe pkgs.jq;

      # Toggle special workspace `name`. If nothing lives on it yet, spawn `run`
      # there: the new window opens on whichever workspace is active, and we've
      # just activated the special one.
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

      # Returns a wlr-which-key menu entry
      scratchpad = { key, desc, run, name ? lib.toLower (lib.replaceStrings [ " " ] [ "-" ] desc) }: {
        inherit key desc;
        cmd = "${scratchpadScript name run}";
      };

      app = key: desc: cmd: { inherit key desc cmd; };

      menu = [
        (app "f" "Floorp" "floorp")
        (app "e" "Dolphin" "dolphin")
        (app "t" "Kitty" "kitty")

        {
          key = "s";
          desc = "Scratchpads";
          submenu = [
            (scratchpad { key = "s"; desc = "Spotify"; run = "spotify"; })
            (scratchpad { key = "d"; desc = "Discord"; run = "discord"; })
            (scratchpad { key = "t"; desc = "Terminal"; run = "kitty"; name = "term"; })
          ];
        }
      ];

      configFile = (pkgs.formats.yaml { }).generate "wlr-which-key.yaml" {
        anchor = "bottom-right";
        inherit menu;
      };

      appMenu = pkgs.writeShellScriptBin "App_Menu" ''
        exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
      '';
    in
    {
      environment.systemPackages = [ appMenu ];
    };
  };
}
