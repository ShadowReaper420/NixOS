{den, ...}:
{
  den.aspects.flugel = {
    includes = [
      den.aspects.nushell
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "nushell")
      den.aspects.stylix
     # den.aspects.niri
      den.aspects.hyprland
      den.aspects.dolphin
      den.aspects.fluorine
      #den.aspects.pihole
      den.aspects.gaming
      den.aspects.utils
      den.aspects.emacs
      den.aspects.os-rebuild
      den.aspects.spotify
      den.aspects.flatpak
    ];
    user = {

      initialPassword = "1234";

      extraGroups = [
        "wheel"
        "libvirtd"
        "disk"
        "networkmanager"
        "docker"
        "fuse"
      ];
    };

    nixos = {config, ...}: {
      #programs.fish.enable = true;

    };

  };
}
