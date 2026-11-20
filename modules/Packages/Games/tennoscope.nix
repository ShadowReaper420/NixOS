# TennoScope (https://github.com/Deftera186/tennoscope) as a den aspect, package included.
#
# Drop this file anywhere in your den `modules/` tree, then include it:
#
#   den.aspects.igloo.includes = [ den.aspects.tennoscope ];   # host  -> environment.systemPackages
#   den.aspects.alice.includes = [ den.aspects.tennoscope ];   # user  -> home.packages
#
# Without OCR (no tesseract in the closure):  den.aspects.tennoscope._.no-ocr
#
# Also exposes `packages.x86_64-linux.tennoscope`. Before the first build, run
# `nix build .#tennoscope.pnpmDeps` and paste the printed hash into `pnpmDeps.hash` below.
#
# Including it on a user currently also leaks the `nixos` half to the host (den's transition
# default, ends 2027-01-01) and prints a warning. Set
# `den.migrations.user-host-content.acknowledged = true;` to keep it home-manager only.
{ lib, ... }:
let
  package =
    {
      lib,
      stdenv,
      rustPlatform,
      fetchFromGitHub,
      fetchPnpmDeps,
      pnpmConfigHook,
      pnpm_10,
      nodejs,
      pkg-config,
      wrapGAppsHook3,
      makeWrapper,
      # libraries
      dbus,
      glib,
      glib-networking,
      gtk3,
      libsoup_3,
      webkitgtk_4_1,
      libayatana-appindicator,
      pipewire,
      libGL,
      libgbm,
      libdrm,
      libxcb,
      wayland,
      openssl,
      # runtime tools
      tesseract,
      xwininfo,
      xdg-utils,
      withOcr ? true,
    }:

    let
      pnpm = pnpm_10;
      # The overlay only needs English traineddata; the default tesseract pulls every language.
      tesseract' = tesseract.override { enableLanguages = [ "eng" ]; };
    in
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "tennoscope";
      version = "0.14.0";

      src = fetchFromGitHub {
        owner = "Deftera186";
        repo = "tennoscope";
        tag = "v${finalAttrs.version}";
        hash = "sha256-P6tnjKZNIAI758cljjAg5WrGraXHzxsBXKJT3ZMln8c=";
      };

      # Read straight from the fetched source (import-from-derivation), so there is no cargo hash
      # and no Cargo.lock copy to keep in sync. Upstream has no git dependencies.
      cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

      env.pnpmRoot = "app";
      env.pnpmDeps = fetchPnpmDeps {
        inherit (finalAttrs) pname version src;
        sourceRoot = "${finalAttrs.src.name}/app";
        inherit pnpm;
        fetcherVersion = 3;
        # First build prints the real hash ("got: sha256-..."); paste it here.
        hash = lib.fakeHash;
      };

      nativeBuildInputs = [
        pnpmConfigHook
        pnpm
        nodejs
        pkg-config
        rustPlatform.bindgenHook # libspa-sys / pipewire-sys generate bindings with bindgen
        wrapGAppsHook3
        makeWrapper
      ];

      buildInputs = [
        dbus
        glib
        glib-networking
        gtk3
        libsoup_3
        webkitgtk_4_1
        libayatana-appindicator
        pipewire
        libGL
        libgbm
        libdrm
        libxcb
        wayland
        openssl
      ];

      # Same as upstream's PKGBUILD / RPM spec: build the frontend, then the binary with
      # tauri/custom-protocol (without it the WebView points at the vite dev server).
      cargoBuildFlags = [
        "-p"
        "tennoscope"
      ];
      buildFeatures = [ "tauri/custom-protocol" ];

      preBuild = ''
        pnpm --dir app build
      '';

      # The workspace tests shell out to real tesseract and screen-capture paths; skip in the sandbox.
      doCheck = false;

      postInstall = ''
        install -Dm644 packaging/tennoscope.desktop $out/share/applications/tennoscope.desktop
        substituteInPlace $out/share/applications/tennoscope.desktop \
          --replace-fail "Exec=/usr/bin/tennoscope" "Exec=tennoscope"
        install -Dm644 app/src-tauri/icons/32x32.png $out/share/icons/hicolor/32x32/apps/tennoscope.png
        install -Dm644 app/src-tauri/icons/128x128.png $out/share/icons/hicolor/128x128/apps/tennoscope.png
        install -Dm644 app/src-tauri/icons/128x128@2x.png $out/share/icons/hicolor/256x256/apps/tennoscope.png
        install -Dm644 THIRD_PARTY_NOTICES.md $out/share/doc/tennoscope/THIRD_PARTY_NOTICES.md
      '';

      # Tesseract (relic overlay OCR), xwininfo (Wine virtual-desktop discovery) and xdg-open
      # (opening links/folders) are all looked up on PATH at runtime.
      preFixup = ''
        gappsWrapperArgs+=(
          --suffix PATH : ${
            lib.makeBinPath ([ xwininfo xdg-utils ] ++ lib.optional withOcr tesseract')
          }
        )
      '';

      passthru = {
        inherit (finalAttrs.env) pnpmDeps;
      };

      meta = {
        description = "Local-first Warframe collection tracker and relic reward overlay";
        homepage = "https://github.com/Deftera186/tennoscope";
        changelog = "https://github.com/Deftera186/tennoscope/blob/v${finalAttrs.version}/CHANGELOG.md";
        license = lib.licenses.gpl3Only;
        mainProgram = "tennoscope";
        platforms = [ "x86_64-linux" ];
        maintainers = [ ];
      };
    });

  tennoscope = pkgs: args: pkgs.callPackage package args;

  mkAspect = args: {
    description = "TennoScope Warframe relic overlay and collection tracker";
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ (tennoscope pkgs args) ];
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ (tennoscope pkgs args) ];
      };
  };
in
{
  den.aspects.tennoscope = mkAspect { } // {
    provides.no-ocr = mkAspect { withOcr = false; };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.tennoscope = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") (
        tennoscope pkgs { }
      );
    };
}
