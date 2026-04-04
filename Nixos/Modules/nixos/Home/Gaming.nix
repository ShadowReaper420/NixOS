{
  config,
  lib,
  pkgs,
  inputs,
  systemSettings,
   userSettings,
  pkgs-stable,
  ...
}: {
  environment.systemPackages = 

    ( with pkgs; [
    
    prismlauncher-unwrapped
    bottles
    steamtinkerlaunch
    #openmw
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
    ]
    ++
    [
      (umu-launcher.override {
        extraPkgs = pkgs: [
         proton-ge-bin
        ];

      })
    ]);

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

}
