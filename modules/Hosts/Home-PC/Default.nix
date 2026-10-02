{self, den, ...}:
{

  den.hosts.x86_64-linux.home.users.flugel = {};

  den.aspects.home = {
    includes = [
      # den.aspects.gaming
      # den.aspects.utils
      # den.aspects.emac
      #den.aspects.hyprland
      den.aspects.gaming
      den.aspects.utils
      den.aspects.emacs
      den.aspects.spotify
      den.aspects.flatpak 
      #den.aspects.niri
      #den.aspects.kanshi

    ];

    provides.to-users.homeManager = { pkgs, ... }: {

      #monitor settings for the host
      services.kanshi = {
        enable = true;
        settings = [
          {
            profile.name = "home";
            profile.outputs = [
              {
                criteria = "DP-2";
                position = "0,0";
                mode = "2560x1440@144Hz";
                scale = 1.0;
              }
              {
                criteria = "HDMI-A-1";
                position = "2560,0";
                mode = "1920x1080@60Hz";
                scale = 1.0;
              }

            ];
          }
        ];
      };

      home.packages = [];
    };


    nixos =
      { pkgs, config, ... }:    {




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




              services.pulseaudio.enable = false;
              services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
              };

              networking.networkmanager.enable = true;

              #TODO clean this shit up

              boot.kernelPackages = pkgs.linuxPackages_latest;

              nix.settings.experimental-features = ["nix-command" "flakes"];

              programs.nix-ld.enable = true; 
              systemd.enableEmergencyMode = false;
              services.flatpak.enable = true;

              # # Enable networking
              # networking.networkmanager.enable = true;

              # Set your time zone.
              time.timeZone = "America/New_York";

              # Select internationalisation properties.
              i18n.defaultLocale = "en_US.UTF-8";

              i18n.extraLocaleSettings =
                let
                  x = "en_US.UTF-8";
                in
                {
                  LC_ADDRESS = x;
                  LC_IDENTIFICATION = x;
                  LC_MEASUREMENT = x;
                  LC_MONETARY = x;
                  LC_NAME = x;
                  LC_NUMERIC = x;
                  LC_PAPER = x;
                  LC_TELEPHONE = x;
                  LC_TIME = x;
                };
                services.xserver.enable = true;
                services.xserver.excludePackages = [pkgs.xterm];



                # Configure keymap in X11
                services.xserver.xkb = {
                  layout = "us";
                  variant = "";
                };

                #   # Enable sound with pipewire.
                #   services.pulseaudio.configFile = pkgs.runCommand "default.pa" {} ''
                #     sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
                #     ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
                #   ''; 
                #   services.pulseaudio.enable = false;
                #   security.rtkit.enable = true;


      };
  };
}

