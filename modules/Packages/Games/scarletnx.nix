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
      runCommand,
      runtimeShell,
      coreutils,
      dwarfs,
      squashfsTools,
      binutils,
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
        # Matches the nightly this hash was taken from. `latest/download` moves with every upstream push,
        # so when the build reports a hash mismatch, either update this or pin a release URL (see above).
        hash = "sha256-4v5t2Fey4/Kgceo/yiDZofmmwoGaNOOyLXy24obcFps=";
      };

      # Unpack the AppImage's filesystem without running its runtime (it is dynamically linked, so it
      # can't execute in the sandbox: "required file not found"). nixpkgs' appimageTools.extract only
      # understands SquashFS, while AppImages from newer tooling (uruntime) are often DwarFS, so try
      # DwarFS first and fall back to SquashFS at the end of the ELF runtime.
      extracted =
        runCommand "${pname}-${version}-extracted"
          {
            nativeBuildInputs = [
              # nixpkgs' dwarfs test suite aborts in 6 dwarfsextract_format tests on some revisions, which fails
              # the whole build. Don't set doCheck = false: that turns tests off in dwarfs' CMake configure, and its
              # ricepp subproject then tries to download googletest with git (no network in the sandbox). Keep the
              # build configured as it is and only let the test run's failure be ignored.
              (dwarfs.overrideAttrs (old: {
                checkPhase = ''
                  runHook preCheck
                  make test -j$NIX_BUILD_CORES || echo "ignoring failing dwarfs tests"
                  runHook postCheck
                '';
              }))
              squashfsTools
              binutils # readelf, for the SquashFS fallback
            ];
          }
          ''
            # dwarfsextract chdirs into the output directory, so it must exist
            mkdir -p "$out"
            if dwarfsextract -i ${src} -O auto -o "$out"; then
              echo "unpacked a DwarFS image"
            else
              echo "not a DwarFS image, trying SquashFS" >&2
              rm -rf "$out"
              shoff=$(readelf -h ${src} | awk '/Start of section headers/ {print $5}')
              shentsize=$(readelf -h ${src} | awk '/Size of section headers/ {print $5}')
              shnum=$(readelf -h ${src} | awk '/Number of section headers/ {print $5}')
              offset=$((shoff + shentsize * shnum))
              echo "trying SquashFS at offset $offset" >&2
              unsquashfs -no-progress -d "$out" -o "$offset" ${src}
            fi
            [ -e "$out/AppRun" ] || { echo "no AppRun in the extracted AppImage" >&2; ls -la "$out" >&2; exit 1; }
          '';

      desktopItem = makeDesktopItem {
        name = pname;
        desktopName = "ScarletNX";
        comment = "ARM64 recompiler with a Nintendo Switch translation layer";
        exec = pname;
        icon = pname;
        categories = [
          "Game"
          "Emulator"
        ];
      };
    in
    appimageTools.wrapAppImage {
      inherit pname version;
      src = extracted;

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

      # How ScarletNX plays a game inside an AppImage: it deploys a *copy of $APPIMAGE* named after the game
      # (recompiled/<id>/<id>) and runs that copy; the runtime then takes its name and folder from $APPIMAGE and
      # loads <id>_code.so (src/nx/runtime/main.c program_path, driver/recompile.c snx_own_runtime). A normal
      # AppImage is a single file, but here $APPIMAGE is unset and the "runtime" would be sharun's launcher, which
      # does nothing once copied out ("Failed to find '<id>' in PATH ..."). So bin/scarletnx becomes a small
      # script that acts as the AppImage file: it sets APPIMAGE to its own path and APPDIR to the unpacked image,
      # then starts the FHS wrapper. Copies of the script work the same, from wherever the launcher put them.
      extraInstallCommands = ''
        mkdir -p $out/libexec $out/share/applications
        mv $out/bin/${pname} $out/libexec/${pname}-fhs
        cat > $out/bin/${pname} <<'NOLVUS_SCRIPT'
        #!${runtimeShell}
        APPIMAGE=$(${coreutils}/bin/readlink -f "$0")
        export APPIMAGE
        export APPDIR=${extracted}
        exec ${placeholder "out"}/libexec/${pname}-fhs "$@"
        NOLVUS_SCRIPT
        chmod +x $out/bin/${pname}

        # Desktop entry, and the icon shipped inside the AppImage (Wimsy, the mascot) if there is one.
        cp ${desktopItem}/share/applications/* $out/share/applications/
        icon="$(find ${extracted} -maxdepth 1 \( -name '*.svg' -o -name '*.png' \) | head -n1)"
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
