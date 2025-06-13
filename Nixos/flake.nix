{
  description = "The Source of all my suffering";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.11";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";

    nur = {
      url = "github:nix-community/NUR/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
};


   # microvm = {
    #  url = "github:astro/microvm.nix";
   #   inputs.nixpkgs.follows = "nixpkgs";
   # };

  };

  outputs = {
    nixpkgs,
    home-manager,
    nur,
    aagl,
    pyprland,
    hyprpanel,
    nix-flatpak,
   # nixpkgs-stable,
    niri,
    #microvm,
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
        inputs.hyprpanel.overlay
        inputs.niri.overlays.niri
      ];
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      modules = [
        ./System/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.nur.modules.nixos.default
        inputs.nixvim.nixosModules.nixvim
        inputs.niri.nixosModules.niri
        inputs.nix-flatpak.nixosModules.nix-flatpak
        #inputs.microvm.nixosModules.microvm

        {
          environment.systemPackages = [pyprland.packages."x86_64-linux".pyprland];
          imports = [aagl.nixosModules.default];
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.${userSettings.username} = import ./Home-Manager/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit systemSettings;
            inherit userSettings;
            inherit aagl;
            #inherit pkgs-stable;
            inherit niri;
          };
        }
      ];
      specialArgs = {
        inherit inputs;
        inherit systemSettings;
        inherit userSettings;
        #inherit pkgs-stable;
        
      };
    };
  };
}
