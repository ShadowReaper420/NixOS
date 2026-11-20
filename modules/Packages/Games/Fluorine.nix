{den, lib, ...}:
{
  den.aspects.fluorine = {

    nixos = {pkgs, ...}: {
      services.envfs.enable = true;
      programs.fuse.userAllowOther = true;

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        libGL
        libGLX
        libxcb
        nspr
        nss
        libgbm
        fontconfig
        libX11
        libxkbcommon
        stdenv.cc.cc.lib # libstdc++
        wayland
        dotnet-runtime_10
        libgpg-error
      ];

    };
 
    home-Manager = {config, ...}: {
      
      xdg.desktopEntries.fluorine-nxm-handler = {
        name = "Fluorine Manager NXM Handler";
        exec = "${config.home.homeDirectory}/.local/bin/mo2-nxm-handler %u";
        mimeType= [ "x-scheme-handler/nxm" "x-scheme-handler/modl" ];
        noDisplay = true;
      };

      # nxm link association
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/nxm" = ["fluorine-manager.desktop"];
        "x-scheme-handler/modl" = ["fluorine-manager.desktop"];
      };

    };


  };
}
