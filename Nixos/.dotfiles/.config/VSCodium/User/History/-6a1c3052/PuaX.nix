{
  description = "Your new nix config";
  import = [
    ./pkgs/Flakestuff/Hyprsplit.nix
  ];

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
  let
    
   


   # _____SYSTEM SETTINGS______ #
   systemSettings = {
     system = "x86_64-linux"; #System Arch
     hostname = "Steller"; # hostname
     timezone = "America/New_York"; # Timezone
     locale = "en_US.UTF-8"; # Locale
     bootloader = "GRUB"; # Sets your bootloader. This one is really awkward to change, Just don't mess with it, all the other bootloaders suck anyways.
   };
   
   #_____USER SETTINGS_____ #
    userSettings = {
     username = "flugel"; # username
     name = "Flugel"; # name
     email = "Shadowreaper26@proton.me"; # email, pretty much exists solely for git.
     #theme = "" #Sets colour theme
     icons = "BeautyLine"; # Sets the icon theme
     font = "Intel One Mono"; # Sets the font
     fontPkg = pkgs.intel-one-mono; # Font package
     wm = "hyprland"; #selected WM or DE
     wmType = "wayland"; # x11 or wayland
     browser = "floorp"; # Web browser, pick your posion.
     editor = "neovim"; # Sets the default text editor. used for some system stuff and keybinds.
     fileManager = "dolphin"; # Sets the file manager, used in keybinds.
     terminal = "kitty"; # Sets your terminal. I only have Kitty installed by default, but this is used in keybinds, so change this if you install another one.
     Shell = "zsh"; # Sets your shell.
   };
    
  };


























   



    
    ...
  in } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    #nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    #homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
        nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit 
          #inputs
          #outputs
          userSettings
          systemSettings

          ;};
        




        modules = [
          # > Our main nixos configuration file <
          ./nixos/configuration.nix
          inputs.stylix.nixosModules.stylix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    #homeConfigurations = {
      # FIXME replace with your username@hostname
     # "flugel@nixos" = home-manager.lib.homeManagerConfiguration {
     #   pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
     #   extraSpecialArgs = {inherit inputs outputs;};
     #   modules = [
     #     # > Our main home-manager configuration file <
     #     ./home-manager/home.nix
     #   ];
    #  };
  #  };
  };
}
