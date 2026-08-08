{den, ...}: {

  den.hosts.x86_64-linux.workstation.users.flugel = { };

  den.aspects.workstation = {
    includes = [
      den.aspects.hyprland
      den.aspects.flugel
      # den.aspects.gaming
      # den.aspects.utils
      # den.aspects.emac
      den.aspects.hyprland
      den.aspects.gaming
      den.aspects.utils
      den.aspects.emacs
      den.aspects.spotify

    ];
  };

}
