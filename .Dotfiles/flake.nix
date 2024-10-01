{
  description = "The Source of all my suffering";

   
 inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };



   outputs = { nixpkgs, home-manager, ... } @ inputs:

  let
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
     #theme = "" #Sets colour theme
     icons = "BeautyLine"; # Sets the icon theme
     font = "Intel One Mono"; # Sets the font
     #fontPkg = pkgs.intel-one-mono; # Font package
     wm = "hyprland"; #selected WM or DE
     wmType = "wayland"; # x11 or wayland
     browser = "floorp"; # Web browser, pick your posion.
     editor = "neovim"; # Sets the default text editor. used for some system stuff and keybinds.
     fileManager = "dolphin"; # Sets the file manager, used in keybinds.
     terminal = "kitty"; # Sets your terminal. I only have Kitty installed by default, but this is used in keybinds, so change this if you install another one.
     Shell = "zsh"; # Sets your shell.
   };
     lib = nixpkgs.lib;
     pkgs = nixpkgs.legacyPackages.${systemSettings.system};
 in {
  
  nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    modules = [
      ./System/configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${userSettings.username} = import ./home.nix;
        home-manager.extraSpecialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
          inherit pkgs;
        };
      }
    ];
      specialArgs = {
      inherit inputs;
      inherit systemSettings;
      inherit userSettings;
      inherit pkgs;
      inherit lib;

      };
     };
   };
}

   
