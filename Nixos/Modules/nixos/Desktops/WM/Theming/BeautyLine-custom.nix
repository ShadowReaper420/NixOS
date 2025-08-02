{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  #breeze-icons,
  gtk3,
  gnome-icon-theme,
  hicolor-icon-theme,
  mint-x-icons,
  candy-icons,
  pantheon,
  jdupes,
  pkgs,
}:

stdenvNoCC.mkDerivation rec {
  pname = "BeautyLine";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "ShadowReaper420";
    repo = pname;
    rev = version;
    sparseCheckout = [
      "BeautyLine-V3"
    ];
    hash = "sha256-PKO6Mob23NlVgCOJ5guBd/KEZ8KrYPuJyUyomOSOIuU";
  };

  sourceRoot = "${src.name}/BeautyLine-V3";

  nativeBuildInputs = [
    jdupes
    gtk3
  ];

  # ubuntu-mono is also required but missing in ubuntu-themes (please add it if it is packaged at some point)
  propagatedBuildInputs = [
    candy-icons
    #breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
    mint-x-icons
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/${pname}
    cp -r * $out/share/icons/${pname}/
    gtk-update-icon-cache $out/share/icons/${pname}

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "BeautyLine icon theme";
    homepage = "https://www.gnome-look.org/p/1425426/";
    platforms = platforms.linux;
    license = [ licenses.publicDomain ];
    maintainers = with maintainers; [ gvolpe ];
  };
}
