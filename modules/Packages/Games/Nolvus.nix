# Nolvus Dashboard: package + Den aspect in one file.
#
# Drop this (plus the generated deps.json next to it) into your Den config, e.g.
# modules/nolvus-dashboard/aspect.nix, and select it on a host:
#   den.aspects.<host>.includes = [ den.aspects.nolvus-dashboard ];
#
# This is also a flake-parts module: it exposes packages.<system>.nolvus-dashboard (for
# `nix build .#nolvus-dashboard` and fetch-deps) and flake.overlays.default. If you use Den
# without flake-parts, delete the `flake` attribute at the bottom.
{ den, lib, inputs, ... }:
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
    coreutils,
    sevenzip, # the app runs ./lib/7z (see postInstall)
    copyDesktopItems,

    # Tools the dashboard shells out to via PATH (xrandr, glxinfo, lspci, pgrep, tar, chmod, bash, dotnet).
    # protontricks/winetricks are no longer needed: Fluorine handles the Proton prefix itself.
    bash,
    gnutar,
    mesa-demos,
    pciutils,
    procps,
    xrandr,
    xwayland,
    findutils,
    perl,
    xdelta, # provides xdelta3 for lib/xdelta3 (see postInstall)
    autoPatchelfHook,
    stdenv,

    # The release tarball (Binaries-<version>.tar.gz). Upstream doesn't keep lib/ in git: BSArch and
    # the game patches (lib/Patches) only exist in releases. null = skip (installs will then fail).
    releaseTarball ? null,

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
    lz4, # needed by the prebuilt BSArch (liblz4.so.1)
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
    # Must be the real, numeric version from Nolvus.Dashboard.csproj (<Version>/<InformationalVersion>):
    # buildDotnetModule stamps it into the assembly, and the app parses it at runtime (GlobalsService.GetVersion).
    # Update it whenever you bump `rev`.
    version = "3.8.14.0";

    src = fetchFromGitHub {
      owner = "sableeyed";
      repo = "NolvusDashboard";
      rev = "a3a07759241440384c1c03c1adf1010a09c86a72";
      hash = "sha256-0v55nqpMr9MBE2vISknJ2opB/ojkDGtPC9Y5Az9GT+k=";
    };

    # Both projects are published into the same output directory, exactly like upstream's build.sh.
    projectFile = [
      "Nolvus.Dashboard/Nolvus.Dashboard.csproj"
      "Nolvus.Updater/Nolvus.Updater.csproj"
    ];

    # Bootstrap: this file doesn't exist until you generate it with fetch-deps, and flakes can't
    # see it until it is `git add`ed. With null, the config still evaluates and fetch-deps works;
    # only *building* the package fails until deps.json exists.
    nugetDeps = if builtins.pathExists ./deps.json then ./deps.json else null;

    # The repo has a local dotnet tool manifest (dotnet-stryker, a mutation-testing tool). The
    # configure hook runs `dotnet tool restore` when it exists, which can't find the tool in
    # the offline NuGet deps. We don't need it to build, so drop the manifest.
    postPatch = ''
      rm -f .config/dotnet-tools.json dotnet-tools.json

      # Archives with legacy-codepage file names are extracted by 7z with raw non-UTF-8 bytes in the
      # file name. .NET then can't find those files by the (mangled) name it enumerates, and
      # SetAttributesNormal throws FileNotFoundException, aborting the mod install. File attributes
      # are meaningless on Linux anyway, so make the calls best-effort.
      substituteInPlace Nolvus.Services/Files/FileService.cs \
        --replace-fail "File.Attributes = FileAttributes.Normal;" "try { File.Attributes = FileAttributes.Normal; } catch { }" \
        --replace-fail "Directory.Attributes = FileAttributes.Normal;" "try { Directory.Attributes = FileAttributes.Normal; } catch { }"

      # Google Drive's old uc?export=download endpoint now often returns an HTML interstitial that the
      # downloader's link detection doesn't recognise, so the HTML gets saved as the file (and fails the
      # CRC check three times). drive.usercontent.google.com/download is the direct-download endpoint.
      # UNVERIFIED: if Drive is rate-limiting that file, this won't help.
      substituteInPlace Nolvus.Services/Files/Downloaders/GoogleDriveFileDownloader.cs \
        --replace-fail 'https://drive.google.com/uc?id=' 'https://drive.usercontent.google.com/download?id='
    '';

    dotnet-sdk = dotnetCorePackages.sdk_10_0;
    dotnet-runtime = dotnetCorePackages.runtime_10_0;

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

    nativeBuildInputs = [
      copyDesktopItems
      autoPatchelfHook
    ];

    # For the prebuilt BSArch from the release tarball; libcef & co are covered by runtimeDeps.
    buildInputs = [ stdenv.cc.cc.lib ];
    autoPatchelfIgnoreMissingDeps = true;

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
      lz4
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
        bash
        coreutils
        dotnet-runtime
        gnutar
        mesa-demos
        pciutils
        procps
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
    
      # <app dir>/lib is where the app looks for 7z, xdelta3, BSArch and Patches/. Upstream only ships it
      # in release tarballs, so take BSArch + Patches from there, but use nixpkgs' 7-Zip and xdelta3
      # (they work on NixOS without patching).
      app_lib=$out/lib/${pname}/lib
      mkdir -p "$app_lib"
      ${lib.optionalString (releaseTarball != null) ''
        mkdir -p "$TMPDIR/release"
        tar -xzf ${releaseTarball} -C "$TMPDIR/release" --strip-components=1
        if [ -d "$TMPDIR/release/lib" ]; then
          cp -r --no-preserve=ownership "$TMPDIR/release/lib/." "$app_lib/"
          chmod -R u+w "$app_lib"
        else
          echo "warning: no lib/ directory in the release tarball" >&2
        fi
      ''}
      rm -f "$app_lib/7z" "$app_lib/xdelta3"
      [ -x "${sevenzip}/bin/7zz" ] || { echo "no 7zz binary found in ${sevenzip}/bin" >&2; exit 1; }

      # lib/7z is a wrapper around 7zz. Zip archives made on Windows often store file names in a legacy
      # codepage (no UTF-8 flag); 7zz then writes raw non-UTF-8 bytes into the file names on Linux, which
      # .NET cannot open or delete (it only sees U+FFFD, "Directory not empty", "Could not find file").
      # After extraction the wrapper renames such entries to valid UTF-8, decoding them as CP437, which is
      # what 7-Zip on an English Windows would have done, so the result matches the Windows install.
      mkdir -p $out/libexec
      cat > $out/libexec/nolvus-fix-names.pl <<'NOLVUS_PERL'
      use strict;
      use warnings;
      use Encode qw(decode encode);
      $/ = "\0";
      while (my $p = <STDIN>) {
        chomp $p;
        next unless $p =~ m{^(.*)/([^/]+)$};
        my ($dir, $base) = ($1, $2);
        my $test = $base;
        next if utf8::decode($test);    # already valid UTF-8 (includes plain ASCII)
        my $new = encode("UTF-8", decode("cp437", $base));
        $new =~ s{/}{_}g;
        my $target = "$dir/$new";
        my $i = 1;
        while (-e $target) {
          $target = "$dir/$new.$i";
          $i++;
        }
        rename($p, $target);
      }
      NOLVUS_PERL

      cat > "$app_lib/7z" <<'NOLVUS_7Z'
      #!${runtimeShell}
      ${sevenzip}/bin/7zz "$@"
      rc=$?
      out=""
      for a in "$@"; do
        case "$a" in
          -o*) out=$(printf %s "$a" | tail -c +3) ;;
        esac
      done
      if [ -n "$out" ] && [ -d "$out" ]; then
        ${findutils}/bin/find "$out" -depth -print0 | ${perl}/bin/perl ${placeholder "out"}/libexec/nolvus-fix-names.pl || true
      fi
      exit $rc
      NOLVUS_7Z
      chmod +x "$app_lib/7z"
      ln -s "${xdelta}/bin/xdelta3" "$app_lib/xdelta3"
    '';

    # Same trick as upstream's build.sh: the CefGlue NuGet package ships its browser subprocess as a
    # *self-contained* .NET 8 app. Replace it with a launcher that uses the Nix-provided runtime
    # (rollForward=Major lets the newer runtime run it) and drop the bundled runtime copy.
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

      # The dashboard writes next to its own binary (Logs/, probably more), which is impossible in
      # the read-only store. .NET derives its base directory from the real location of the apphost,
      # so symlinks back into the store don't help. Instead, the real apphost is renamed and
      # replaced by a launcher that keeps a writable per-user copy of the app directory (refreshed
      # whenever the package changes) and runs the apphost from there. The nixpkgs wrapper in
      # $out/bin still sets DOTNET_ROOT, LD_LIBRARY_PATH and PATH, which the copy inherits.
      app_dir="$out/lib/${pname}"
      for exe in NolvusDashboard NolvusUpdater; do
        if [ -f "$app_dir/$exe" ]; then
          mv "$app_dir/$exe" "$app_dir/$exe.real"
          cat > "$app_dir/$exe" <<'NOLVUS_LAUNCHER'
      #!${runtimeShell}
      set -eu
      export PATH="${lib.makeBinPath [ coreutils ]}:$PATH"
      src="${placeholder "out"}/lib/${pname}"
      dst="''${XDG_DATA_HOME:-$HOME/.local/share}/nolvus-dashboard/app"
      stamp="$dst/.nix-store-path"
      if [ ! -f "$stamp" ] || [ "$(cat "$stamp")" != "$src" ]; then
        mkdir -p "$dst"
        cp -rT --remove-destination --reflink=auto "$src" "$dst"
        chmod -R u+w "$dst"
        printf '%s' "$src" > "$stamp"
      fi
      exec "$dst/$(basename "$0").real" "$@"
      NOLVUS_LAUNCHER
          chmod +x "$app_dir/$exe"
        fi
      done
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
  # nixpkgs' plain 7-Zip (_7zz) and p7zip are built WITHOUT RAR support (the unRAR code has a
  # non-free licence). Mod archives are often .rar, so we use the _7zz-rar variant, which is
  # unfree: allow it on your system, e.g. nixpkgs.config.allowUnfreePredicate with the package
  # name from the "refusing to evaluate" error. To avoid unfree software, change this to
  # `pkgs._7zz` (then .rar archives will fail to extract).
  mkNolvus =
    pkgs:
    pkgs.callPackage nolvus-dashboard {
      sevenzip = pkgs._7zz-rar;

      # BSArch and the game patches (lib/Patches) only exist in the release tarball.
      releaseTarball = pkgs.fetchurl {
        url = "https://github.com/sableeyed/NolvusDashboard/releases/download/3.8.14/Binaries-3.8.14.tar.gz";
        hash = "sha256-6y6X9SOADC0GEdgYuY2kgfO/R2S+TdehY0jEbGnXVzA=";
      };
    };
in
{
  den.aspects.nolvus-dashboard = {
    includes = [ ];

    # System-wide install on NixOS hosts.
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ (mkNolvus pkgs) ];

        # Nolvus needs Steam + Proton; mkDefault so a gaming aspect can override.
        programs.steam.enable = lib.mkDefault true;
      };

    # Per-user install (non-NixOS / standalone home-manager).
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ (mkNolvus pkgs) ];
      };
  };

  # Exposed directly as a flake output (not via perSystem) so it exists no matter what
  # `systems` your flake-parts config declares, and so we never depend on perSystem args.
  # `inputs` is the top-level module argument bound in the header above.
  flake.packages.x86_64-linux.nolvus-dashboard =
    mkNolvus inputs.nixpkgs.legacyPackages.x86_64-linux;

  flake.overlays.nolvus-dashboard = final: _prev: {
    nolvus-dashboard = mkNolvus final;
  };
}
