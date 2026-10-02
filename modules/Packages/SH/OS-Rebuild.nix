{ den, ... }:
{
  # Adds an `os-rebuild` command to the system.
  # Include it with `den.aspects.os-rebuild` (e.g. in den.default.includes).
  den.aspects.os-rebuild = {
    nixos = { pkgs, lib, config, ... }:
      let
        cfg = config.programs.os-rebuild;

        os-rebuild = pkgs.writeShellApplication {
          name = "os-rebuild";
          runtimeInputs = [ pkgs.git pkgs.nix pkgs.nixos-rebuild ];
          text = ''
            FLAKE_PATH="''${OS_REBUILD_FLAKE_PATH:-${cfg.flakePath}}"
            HOST="${cfg.host}"
            MODE=""

            usage() {
              echo "Usage: os-rebuild (--build | --switch) [--host NAME] [--path DIR]" >&2
              exit 1
            }

            while [[ $# -gt 0 ]]; do
              case "$1" in
                --build)  MODE="build" ;;
                --switch) MODE="switch" ;;
                --host)   [[ $# -ge 2 ]] || usage; HOST="$2"; shift ;;
                --path)   [[ $# -ge 2 ]] || usage; FLAKE_PATH="$2"; shift ;;
                *)        echo "Unknown argument: $1" >&2; usage ;;
              esac
              shift
            done

            [[ -n "$MODE" ]] || usage

            if [[ ! -f "$FLAKE_PATH/flake.nix" ]]; then
              echo "No flake.nix found in: $FLAKE_PATH" >&2
              echo "Set programs.os-rebuild.flakePath, or pass --path DIR." >&2
              exit 1
            fi

            cd "$FLAKE_PATH"

            # Flakes only see git-tracked files; mark new files as intent-to-add
            # so they are visible without staging their contents.
            track() {
              if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
                git add --intent-to-add . 2>/dev/null || true
              fi
            }

            track
            echo ">> Regenerating flake.nix (write-flake)"
            nix run .#write-flake
            track

            case "$MODE" in
              build)
                echo ">> Building nixosConfigurations.$HOST"
                nixos-rebuild build --flake ".#$HOST"
                ;;
              switch)
                echo ">> Switching to nixosConfigurations.$HOST"
                sudo nixos-rebuild switch --flake ".#$HOST"
                ;;
            esac

            echo ">> Done"
          '';
        };
      in
      {
        options.programs.os-rebuild = {
          flakePath = lib.mkOption {
            type = lib.types.str; # str, not path: a path would be copied into the store
            default = "/home/flugel/Work/Repos/NixOS";
            example = "/home/flugel/NixOS-Dev/Nixos";
            description = "Absolute path to the checked-out flake that `os-rebuild` operates on.";
          };

          host = lib.mkOption {
            type = lib.types.str;
            default = config.networking.hostName;
            defaultText = lib.literalExpression "config.networking.hostName";
            description = "Name of the nixosConfiguration to build.";
          };
        };

        config.environment.systemPackages = [ os-rebuild ];
      };
  };
}
