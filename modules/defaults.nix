{ lib, den, ... }:
{
  # enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default = {

    nixos.system.stateVersion = "25.11";
    homeManager.home.stateVersion = "25.11";

    includes = [
      den.provides.define-user
      den.provides.hostname
      den.provides.inputs'
      den.provides.self'
    ];
  



  nixos = {
    fileSystems."/" =
      {
        device = "/dev/disk/by-uuid/961d840f-6ce6-46e8-8938-8ed88e1dc376";
        fsType = "ext4";
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

          boot.loader = {
            efi.canTouchEfiVariables = true;
            grub = {
              #theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
              enable = true;
              useOSProber = true;
              efiSupport = true;
              devices = ["/dev/nvme1n1p1"];
            };
          };
  };
  };
}
