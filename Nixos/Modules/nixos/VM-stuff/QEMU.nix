{config, lib, pkgs, userSettings, systemSettings, ...}:

{

virtualisation.libvirtd = {
  enable =true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm = true;
    ovmf = {
      enable = true;
      packages = [ (pkgs.OVMF.override {
        secureBoot = true;
        tpmSupport = true;
      }).fd ];
    };
  };


};

environment.systemPackages = [
  pkgs.qemu_full
  pkgs.virt-manager
  
] ;
 
}