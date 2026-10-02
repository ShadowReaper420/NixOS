{den, ...}:
{
  den.aspects.flugel = {
    includes = [
      #den.aspects.nushell
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
      den.aspects.stylix
      den.aspects.niri
      den.aspects.hyprland
      den.aspects.dolphin
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
      programs.fish.enable = true;

    };

  };
}
