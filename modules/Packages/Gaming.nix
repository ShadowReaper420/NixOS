{den, inputs, ... }: {

  flake-file = {

    inputs = {
      nexusmods-app.url = "github:MattSturgeon/nma-nix";
      amethyst.url = "github:ChrisDKN/Amethyst-Mod-Manager";
      chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";


    };


  };

  
  den.aspects.gaming = {

    
    
    includes = [
     (den.batteries.unfree ["steam" "steam-unwrapped" "vintagestory" "7zz" "uasm" "unrar" ])
     (den.batteries.insecure ["nexusmods-app-unfree-0.21.1" ])
    ];

    nixos = {pkgs, ...}: {

      imports = [ inputs.chaotic.nixosModules.default ];

      
      environment.systemPackages = 

      ( with pkgs; [
        bottles
        steamtinkerlaunch
        openmw
        winetricks
        wine
        gamescope
        lutris
        protonup-qt
        xivlauncher  
        ryubing
        quantframe
        eden
        vintagestory
        nexusmods-app-unfree   
        heroic-unwrapped
        umu-launcher
        prismlauncher
        pcsx2
        gamemode
        protonup-qt
        inputs.amethyst.packages.${pkgs.stdenv.hostPlatform.system}.default
        satisfactorymodmanager
        xxhash
        
      ]);

      programs.steam = {
        enable = true;
        # protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
          proton-cachyos_x86_64_v3
        ];
      };

      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };
  };

}
