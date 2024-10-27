{config, lib, pkgs, userSettings, systemSettings, ...}:

{

 environment.systemPackages = with pkgs;[
  qemu
  virt-manager
  #quickemu
 ];
}