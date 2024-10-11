# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0bfb7b41-aaf0-4f86-87cf-4dea2d39d4b8";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CF5D-346F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  
  fileSystems."/run/media/flugel/Modding" = 
  {
    device = "/dev/disk/by-uuid/9b5e469d-f501-4976-906b-3794483700d5";
    fsType = "ext4";
  };

 fileSystems."/run/media/flugel/Gaming" = 
  {
    device = "/dev/disk/by-uuid/8d429092-5f47-48a8-bd5b-ab69e975c64e";
    fsType = "ext4";
  };



  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp14s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp15s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
