{den, ...}:
{
  den.aspects.flugel = {
    includes = [
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
      programs.fish.enable = true;


    };

  };
}
