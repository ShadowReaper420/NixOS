# Nolvus Dashboard: package + Den aspect in one file.
#
# Drop this (plus the generated deps.json next to it) into your Den config, e.g.
# modules/nolvus-dashboard/aspect.nix, and select it on a host:
#   den.aspects.<host>.includes = [ den.aspects.nolvus-dashboard ];
#
# This is also a flake-parts module: it exposes packages.<system>.nolvus-dashboard (for
# `nix build .#nolvus-dashboard` and fetch-deps) and flake.overlays.default. If you use Den
# without flake-parts, delete the `perSystem` and `flake` attributes at the bottom.
{ den, lib, ... }:
let
  # The derivation, as a callPackage-style function (its own `lib` arg shadows the outer one).
  nolvus-dashboard =
  {
    lib,
    buildDotnetModule,
    dotnetCorePackages,
    fetchFromGitHub,
    makeDesktopItem,
    runtimeShell,
    copyDesktopItems,

    # Runtime tools the dashboard shells out to (README: "must be accessible in PATH")
    protontricks,
    winetricks,
    xrandr,
    xwayland,

    # Native libraries needed by Avalonia + the bundled Chromium (CefGlue / libcef.so)
    alsa-lib,
    at-spi2-atk,
    at-spi2-core,
    atk,
    cairo,
    cups,
    dbus,
    expat,
    fontconfig,
    freetype,
    glib,
    gtk3,
    icu,
    libdrm,
    libGL,
    libgbm,
    libice,
    libsm,
    libxkbcommon,
    libx11,
    libxcb,
    libxcomposite,
    libxcursor,
    libxdamage,
    libxext,
    libxfixes,
    libxi,
    libxrandr,
    nspr,
    nss,
    openssl,
    pango,
    systemd,
    vulkan-loader,
    zlib,
  }:

  buildDotnetModule rec {
    pname = "nolvus-dashboard";
    # The real version lives in Nolvus.Dashboard.csproj (<Version>); update it when bumping `rev`.
    version = "0-unstable-2026-11-08";

    src = fetchFromGitHub {
      owner = "sableeyed";
      repo = "NolvusDashboard";
      # TODO: pin to a release tag or commit. Get the hash with:
      #   nix run nixpkgs#nix-prefetch-github -- sableeyed NolvusDashboard --rev <rev>
      rev = "main";
      hash = lib.fakeHash;
    };

    # Both projects are published into the same output directory, exactly like upstream's build.sh.
    projectFile = [
      "Nolvus.Dashboard/Nolvus.Dashboard.csproj"
      "Nolvus.Updater/Nolvus.Updater.csproj"
    ];

    # Generate with:  nix build .#default.passthru.fetch-deps && ./result deps.json
    nugetDeps = ./deps.json;

    dotnet-sdk = dotnetCorePackages.sdk_9_0;
    dotnet-runtime = dotnetCorePackages.runtime_9_0;

    # Upstream ships a framework-dependent build (apphost + system runtime).
    selfContainedBuild = false;

    # Matches upstream's -p:DebugType=none -p:DebugSymbols=false
    dotnetFlags = [
      "-p:DebugType=none"
      "-p:DebugSymbols=false"
    ];

    executables = [
      "NolvusDashboard"
      "NolvusUpdater"
    ];

    nativeBuildInputs = [ copyDesktopItems ];

    # Added to the wrapper's LD_LIBRARY_PATH (and used for autoPatchelf). The CEF subprocess
    # inherits this environment because CEF execs it from the wrapped main process.
    runtimeDeps = [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      glib
      gtk3
      icu
      libdrm
      libGL
      libgbm
      libice
      libsm
      libxkbcommon
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      nspr
      nss
      openssl
      pango
      systemd
      vulkan-loader
      zlib
    ];

    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        protontricks
        winetricks
        xrandr
        xwayland
      ])
      # libcef.so dlopens its sibling libs (libEGL, libGLESv2, libvk_swiftshader, ...)
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      "${placeholder "out"}/lib/${pname}"
    ];

    postInstall = ''
      install -Dm644 Nolvus.Dashboard/Assets/nolvus-ico.jpg $out/share/pixmaps/nolvus-dashboard.jpg
    '';

    # Same trick as upstream's build.sh: the CefGlue NuGet package ships its browser subprocess as a
    # *self-contained* .NET 8 app. Replace it with a launcher that uses the Nix-provided runtime
    # (rollForward=Major lets the .NET 9 runtime run it) and drop the bundled runtime copy.
    postFixup = ''
      subproc_dir="$out/lib/${pname}/CefGlueBrowserProcess"
      subproc_host="$subproc_dir/Xilium.CefGlue.BrowserProcess"

      if [ -f "$subproc_host" ]; then
        cat > "$subproc_dir/Xilium.CefGlue.BrowserProcess.runtimeconfig.json" <<'JSON'
      {
        "runtimeOptions": {
          "tfm": "net8.0",
          "rollForward": "Major",
          "framework": { "name": "Microsoft.NETCore.App", "version": "8.0.0" },
          "configProperties": {
            "System.Reflection.Metadata.MetadataUpdater.IsSupported": false,
            "System.Runtime.Serialization.EnableUnsafeBinaryFormatterSerialization": false
          }
        }
      }
      JSON
        rm -f "$subproc_dir/Xilium.CefGlue.BrowserProcess.deps.json"
        (
          cd "$subproc_dir"
          rm -f System.dll System.*.dll Microsoft.*.dll netstandard.dll mscorlib.dll WindowsBase.dll \
            libcoreclr.so libcoreclrtraceptprovider.so libclrjit.so libclrgc.so \
            libhostfxr.so libhostpolicy.so libmscordaccore.so libmscordbi.so \
            libSystem.*.so createdump
        )
        cat > "$subproc_host" <<LAUNCHER
      #!${runtimeShell}
      exec ${dotnet-runtime}/bin/dotnet "$subproc_dir/Xilium.CefGlue.BrowserProcess.dll" "\$@"
      LAUNCHER
        chmod +x "$subproc_host"
      else
        echo "warning: CEF subprocess not found at $subproc_host" >&2
      fi
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "nolvus-dashboard";
        desktopName = "Nolvus Dashboard";
        comment = "Install and manage the Nolvus modlist";
        exec = "NolvusDashboard";
        icon = "nolvus-dashboard";
        categories = [ "Game" ];
      })
    ];

    meta = {
      description = "Linux-native Nolvus Dashboard for installing and managing the Nolvus modlist";
      homepage = "https://github.com/sableeyed/NolvusDashboard";
      license = lib.licenses.gpl3Only;
      platforms = [ "x86_64-linux" ];
      mainProgram = "NolvusDashboard";
      sourceProvenance = with lib.sourceTypes; [
        fromSource
        binaryNativeCode # Chromium (CEF) comes from NuGet
      ];
    };
  }
  ;
in
{
  den.aspects.nolvus-dashboard = {
    includes = [ ];

    # System-wide install on NixOS hosts.
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ (pkgs.callPackage nolvus-dashboard { }) ];

        # Nolvus needs Steam + Proton; mkDefault so a gaming aspect can override.
        programs.steam.enable = lib.mkDefault true;
      };

    # Per-user install (non-NixOS / standalone home-manager).
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ (pkgs.callPackage nolvus-dashboard { }) ];
      };
  };

  perSystem =
    { pkgs, ... }:
    lib.optionalAttrs (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
      packages.nolvus-dashboard = pkgs.callPackage nolvus-dashboard { };
    };

  flake.overlays.nolvus-dashboard = final: _prev: {
    nolvus-dashboard = final.callPackage nolvus-dashboard { };
  };
}
