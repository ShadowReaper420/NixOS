{den, ...}: {


  den.aspects.qemu = {

    nixos = {pkgs, ...}: {

      virtualisation.libvirtd = {
        enable = false;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
        };
      };

      environment.systemPackages = [
        pkgs.qemu
        pkgs.virt-manager
        #pkgs.quickemu
      ];

      homeManager = {pkgs, ...}: {
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };
      };
    };
  };
}
