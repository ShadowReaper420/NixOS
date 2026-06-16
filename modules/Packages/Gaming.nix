{  pkgs, den, ... }: {

  den.aspects.gaming = {

    nixos = {
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
