{den, ...}: {

  den.aspects.docker = {

    nixos = {pkgs, ...}: {

      # virtualisation.podman = {
        #enable = true;
        #};

        virtualisation.docker = {
          enable = true;
          #enableOnBoot = true;
          #autoPrune.enable = false;
        };

        environment.systemPackages = [ pkgs.distrobox pkgs.boxbuddy ];


    };  



  };




}
