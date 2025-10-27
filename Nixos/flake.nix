{
  description = "The Source of all my suffering";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.11";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nur = {
      url = "github:nix-community/NUR/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    pyprland = {
      url = "github:hyprland-community/pyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
     url = "github:DreamMaoMao/mango";
     inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winboat = {
      url = "github:TibixDev/winboat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nix-flatpak = {
      #  url = "github:gmodena/nix-flatpak/?ref=latest";
      # };

      #  nix-qml = {
        #  url = "git+https://git.outfoxxed.me/outfoxxed/nix-qml-support";
        #   inputs.nixpkgs.follows = "nixpkgs";
        #};

      nvf = {
        url = "github:NotAShelf/nvf";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      niri-scratchpad-flake = {
        url = "github:gvolpe/niri-scratchpad";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      quickshell = {
        url = "github:outfoxxed/quickshell";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      noctalia = {
        url = "github:noctalia-dev/noctalia-shell";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.quickshell.follows = "quickshell";  # Use same quickshell version
      };



  };

  outputs = {
    nixpkgs,
    home-manager,
    nur,
    pyprland,
    #nix-flatpak,
    niri,
    chaotic,
    winapps,
    winboat,
    mango,
    ...
  } @ inputs: let
    #________SYSTEM SETTINGS________#
    systemSettings = {
      system = "x86_64-linux"; #System Arch
      hostname = "nixos"; # hostname
      timezone = "America/New_York"; # Timezone
      locale = "en_US.UTF-8"; # Locale
      bootloader = "GRUB"; # Sets your bootloader. This one is really awkward to change, Just don't mess with it, all the other bootloaders suck anyways.
    };

    #________USER SETTINGS________#
    userSettings = {
      username = "flugel"; # username
      name = "Flugel"; # name
      email = "Shadowreaper26@proton.me"; # email, pretty much exists solely for git.
      icons = "BeautyLine"; # Sets the icon theme
      wm = "hyprland"; #selected WM or DE
      wmType = "wayland"; # x11 or wayland
      browser = "floorp"; # Web browser, pick your posion.
      editor = "neovim"; # Sets the default text editor. used for some system stuff and keybinds.
      fileManager = "dolphin"; # Sets the file manager, used in keybinds.
      terminal = "kitty"; # Sets your terminal. I only have Kitty installed by default, but this is used in keybinds, so change this if you install another one.
    };
    pkgs-stable = inputs.nixpkgs-stable;
    pkgs = import nixpkgs {
      inherit (systemSettings) system;
      config.allowUnfree = true;
      overlays = [
        inputs.niri.overlays.niri
      ];
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      modules = [
        ./System/configuration.nix
        #./noctalia.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.mango.nixosModules.mango
        inputs.stylix.nixosModules.stylix
        inputs.nur.modules.nixos.default
        chaotic.nixosModules.default
        inputs.niri.nixosModules.niri
        inputs.spicetify-nix.nixosModules.default
        # inputs.nix-flatpak.nixosModules.nix-flatpak
        #inputs.microvm.nixosModules.microvm
        inputs.nvf.nixosModules.default


        {
          environment.systemPackages = [pyprland.packages."x86_64-linux".pyprland];
          imports = [];
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.${userSettings.username}.imports = [
            ./Home-Manager/home.nix
            inputs.mango.hmModules.mango
          ];
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit systemSettings;
            inherit userSettings;
            inherit niri;
          };
        }
      ];
      specialArgs = {
        inherit inputs;
        inherit systemSettings;
        inherit userSettings;

      };
    };
  };
}
