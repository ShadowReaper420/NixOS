{
  den.aspects.Home-PC = {den, hosts, ...}: {
    includes = with den.aspects; [
      hyprland
      flugel
      gaming
      utils
      emacs
    ];




    nixos =
      { pkgs, ... }:    {

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

              #TODO clean this shit up

              boot.kernelPackages = pkgs.linuxPackages_latest;
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
              nix.settings.experimental-features = ["nix-command" "flakes"];

              programs.nix-ld.enable = true; 
              systemd.enableEmergencyMode = false;
              services.flatpak.enable = true;

              # Enable networking
              networking.networkmanager.enable = true;

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
                #services.xserver.enable = true;
                #services.xserver.excludePackages = [pkgs.xterm];



                # Configure keymap in X11
                services.xserver.xkb = {
                  layout = "us";
                  variant = "";
                };

                # Enable sound with pipewire.
                services.pulseaudio.configFile = pkgs.runCommand "default.pa" {} ''
                  sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
                  ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
                ''; 
                services.pulseaudio.enable = false;
                security.rtkit.enable = true;
                services.pipewire = {
                  enable = true;
                  alsa.enable = true;
                  alsa.support32Bit = true;
                  pulse.enable = true;
                };
      };
  };
}

