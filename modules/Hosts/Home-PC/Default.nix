{self, den, ...}:
{

  den.hosts.x86_64-linux.home.users.flugel = { };


  den.aspects.home = {den, host, ...}: {
    includes = [
      den.aspects.hyprland
      den.aspects.flugel
      # den.aspects.gaming
      # den.aspects.utils
      # den.aspects.emac
      den.aspects.hyprland
      den.aspects.gaming
      den.aspects.utils
      den.aspects.emacs
      den.aspects.spotify

    ];

    provides.to-users.homeManager = { pkgs, ... }: {
      home.packages = [];
    };



    nixos =
      { pkgs, config, ... }:    {


        environment.systemPackages = with pkgs; [
          floorp
        ];

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

