{ config, lib, pkgs, ... }:

{
 fileSystems."/run/media/flugel/Modding" =
   { device = "/dev/disk/by-uuid/9b5e469d-f501-4976-906b-3794483700d5";
     fsType = "ext4";
   };

  fileSystems."/run/media/flugel/Gaming" =
    { device = "/dev/disk/by-uuid/8d429092-5f47-48a8-bd5b-ab69e975c64e";
      fsType = "ext4";
    };

  fileSystems."/run/media/flugel/Media" =
    { device = "/dev/disk/by-uuid/dfc9f0b4-1d7a-484e-beca-a91033e58096";
      fsType = "ext4";
    };
}
