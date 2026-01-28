{
  description = "The Source of all my suffering";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix/";
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    #pyprland = {
      #url = "github:hyprland-community/pyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
      #};

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


      nix-flatpak = {
        url = "github:gmodena/nix-flatpak/?ref=latest";
      };

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
          #inputs.nixpkgs.follows = "nixpkgs";
        };

        dankMaterialShell = {
          url = "github:AvengeMedia/DankMaterialShell";
          inputs.nixpkgs.follows = "nixpkgs"; 
        };

        stasis = {
          url = "github:saltnpepper97/stasis";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        nirinit = {
          url = "github:amaanq/nirinit";
          inputs.nixpkgs.follows = "nixpkgs";
        };

  };


  outputs = {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nur,
    dankMaterialShell,
    #   pyprland,
    niri,
    chaotic,
    stasis,
    winapps,
    #winboat,
    mango,
    nirinit,
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

    pkgs-stable = import inputs.nixpkgs-stable {
      system = pkgs.stdenv.hostPlatform.system;
      config.allowUnfree = true;

    };
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
        inputs.nix-flatpak.nixosModules.nix-flatpak
        #inputs.microvm.nixosModules.microvm
        inputs.nvf.nixosModules.default
        inputs.dankMaterialShell.nixosModules.dank-material-shell
        inputs.nirinit.nixosModules.nirinit
        




        {

          imports = [];
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.${userSettings.username}.imports = [
            ./Home-Manager/home.nix
            inputs.mango.hmModules.mango
            inputs.noctalia.homeModules.default
            inputs.dankMaterialShell.homeModules.dank-material-shell
            inputs.dankMaterialShell.homeModules.niri

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
        inherit pkgs-stable;

      };
    };
  };
}

