# ScarletNX (static ARM64 -> x86 recompiler with a Switch translation layer): package + Den aspect.
#
# Drop this file into your Den config (e.g. modules/Packages/Games/ScarletNX.nix) and select it:
#   den.aspects.<host>.includes = [ den.aspects.scarletnx ];   # or from your `gaming` aspect
#
# It repackages upstream's AppImage instead of building from source (see the note at the bottom).
{
  den,
  lib,
  inputs,
  ...
}:
let
  scarletnx =
    {
      lib,
      appimageTools,
      fetchurl,
      makeDesktopItem,
      copyDesktopItems,
      stdenv,
    }:
    let
      pname = "scarletnx";
      # Upstream publishes rolling nightlies; `latest/download` always points at the newest one, so its
      # hash changes with every upstream push. To pin, pick a release at
      # https://github.com/scarletnx/nightly/releases, copy the x86_64 AppImage link into `url`, and update
      # the hash:   nix store prefetch-file --json <url>
      version = "nightly";

      src = fetchurl {
        url = "https://github.com/scarletnx/nightly/releases/latest/download/ScarletNX-linux-x86_64.AppImage";
        # First build: leave as lib.fakeHash, copy the "got: sha256-..." value from the error.
        hash = lib.fakeHash;
      };

      contents = appimageTools.extract { inherit pname version src; };
    in
    appimageTools.wrapType2 {
      inherit pname version src;

      # The AppImage bundles its own libraries (it is built with sharun). Games also need a Vulkan 1.3
      # driver from the host: the loader and the audio/window-system libs below are for the wrapper's FHS env.
      extraPkgs =
        pkgs: with pkgs; [
          vulkan-loader
          libGL
          libxkbcommon
          wayland
          alsa-lib
          libpulseaudio
          pipewire
          libx11
          libxext
          libxrandr
          libxcursor
          libxi
          libxfixes
          libxscrnsaver
          libxtst
        ];

      nativeBuildInputs = [ copyDesktopItems ];

      desktopItems = [
        (makeDesktopItem {
          name = pname;
          desktopName = "ScarletNX";
          comment = "ARM64 recompiler with a Nintendo Switch translation layer";
          exec = pname;
          icon = pname;
          categories = [
            "Game"
            "Emulator"
          ];
        })
      ];

      # Reuse the icon shipped inside the AppImage (Wimsy, the mascot) if there is one.
      extraInstallCommands = ''
        icon="$(find ${contents} -maxdepth 1 \( -name '*.svg' -o -name '*.png' \) | head -n1)"
        if [ -n "$icon" ]; then
          ext="''${icon##*.}"
          install -Dm444 "$icon" "$out/share/icons/hicolor/scalable/apps/${pname}.$ext"
        fi
      '';

      meta = {
        description = "Static ARM64 to x86 recompiler with a Nintendo Switch translation layer";
        homepage = "https://scarletnx.github.io/";
        license = lib.licenses.gpl3Only;
        platforms = [ "x86_64-linux" ];
        mainProgram = pname;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };
    };

  mkScarletnx = pkgs: pkgs.callPackage scarletnx { };
in
{
  den.aspects.scarletnx = {
    includes = [ ];

    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ (mkScarletnx pkgs) ];
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ (mkScarletnx pkgs) ];
      };
  };

  # `nix build .#scarletnx`
  flake.packages.x86_64-linux.scarletnx = mkScarletnx inputs.nixpkgs.legacyPackages.x86_64-linux;
}

# Why not build from source?
# ScarletNX's CMake build fetches ~25 pinned dependencies at configure time through CPM and builds FFmpeg,
# OpenSSL, curl, dav1d and jemalloc itself with their own configure scripts, and its docs ask for a very new
# Clang (CI uses 23) plus LLVM development files. In the Nix sandbox every one of those downloads would have to
# be prefetched and handed to CPM (CPM_<name>_SOURCE) and the build steps checked against a toolchain nixpkgs
# may not ship yet. The AppImage is the supported artifact and needs none of that.
