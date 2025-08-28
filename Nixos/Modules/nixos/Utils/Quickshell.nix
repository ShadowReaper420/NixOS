{ config, systemSettings, userSettings, inputs, lib, pkgs, ... }:



{
  environment.systemPackages = with pkgs; [
     inputs.quickshell.packages.${systemSettings.system}.default
     kdePackages.qt5compat
     kdePackages.qtmultimedia
     kdePackages.qtsvg
     kdePackages.qtimageformats
      inputs.nix-qml.packages.${systemSettings.system}.tree-sitter-qmljs
      inputs.nix-qml.packages.${systemSettings.system}.qml-ts-mode
  ];
  qt.enable = true;

  imports = [];

  home-manager.users.${userSettings.username} = {
    home.sessionVariables = {
      QML2_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" [
        inputs.quickshell.packages.${systemSettings.system}.default
        pkgs.kdePackages.qt5compat

      ];
    };

  };
}
