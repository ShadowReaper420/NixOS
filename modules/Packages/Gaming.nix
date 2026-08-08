{den, ... }: {

  den.aspects.gaming = {lib, ...}: {

    
    includes = [
     (den.batteries.unfree ["steam" "steam-unwrapped" "vintagestory" "7zz" "uasm"  ])
     (den.batteries.insecure ["nexusmods-app-unfree-0.21.1" ])
    ];

    nixos = {pkgs, ...}: {
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
        #quantframe
        eden
        vintagestory
        nexusmods-app-unfree 
        heroic-unwrapped
        umu-launcher
        prismlauncher
        pcsx2
        
      ]);

      programs.steam = {
        enable = true;
        # protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };
  };

}
