{den, ...}:
{
  den.aspects.flugel = {
    includes = [
      den.aspects.nushell
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "nushell")
    ];
    user = {
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


    };

  };
}
