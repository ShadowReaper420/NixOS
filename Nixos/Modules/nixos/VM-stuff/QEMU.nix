{
  config,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  ...
}: {
  virtualisation.libvirtd = {
    enable = true;
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

  home-manager.users.${userSettings.username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
