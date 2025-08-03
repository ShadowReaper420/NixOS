{ config, systemSettings, userSettings, inputs, lib, pkgs, ... }:

{
  home-manager.users.${userSettings.username} = {
    home.sessionVariables = {
      QML2_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" [
        inputs.quickshell.packages.${systemSettings.system}.default
        pkgs.kdePackages.qt5compat
        pkgs.libsForQt5.qt5.qtgraphicaleffects

      ];
    };

  };
}
