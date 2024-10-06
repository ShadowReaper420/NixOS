{config, lib, pkgs, systemSettings, userSettings, ...}:
{
  nixpkgs.overlays = [
    (final: prev: beauty-line-icon-theme = prev.beauty-line-icon-theme.override {
      propagatedBuildInputs = [
        candy-icons
        breeze-icons
        hicolor-icon-theme
        mint-x-icons
        pantheon.elementary-icon-theme
      ];

    } )
  ];

}