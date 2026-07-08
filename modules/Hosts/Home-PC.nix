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
    { pkgs, host, ... }:
    {
      #TODO clean this shit up

      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          #theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
          enable = true;
          useOSProber = true;
          efiSupport = true;
          devices = ["nodev"];
        };
      };
      nix.settings.experimental-features = ["nix-command" "flakes"];

      programs.nix-ld.enable = true;
      #The things I do for skyrim modding
      security.pam.loginLimits = [{
        domain = host.name;
        type = "soft";
        item = "nofile";
        value = "32768";
      }];


      systemd.enableEmergencyMode = false;
      services.flatpak.enable = true;

      networking.hostName = "Alpha"; # Define your hostname.


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

        # Enable the X11 windowing system.
        # You can disable this if you're only using the Wayland session.
        services.xserver.enable = true;
        services.xserver.excludePackages = [pkgs.xterm];



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

        # Define a user account. Don't forget to set a password with ‘passwd’.
        #  users.users.${userSettings.username} = {
          #  description = userSettings.name;
          #  extraGroups = ["networkmanager" "wheel" "libvirtd" "disk" "networkmanager" "docker"];
          #};

    };
  };
}

