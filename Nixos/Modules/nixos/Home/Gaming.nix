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

  with pkgs; [
    
    prismlauncher-unwrapped
    bottles
    steamtinkerlaunch
    #openmw
    winetricks
    wine
    gamescope
    lutris
    nexusmods-app-unfree
    protonup-qt
    xivlauncher
    ryubing
    #quantframe
    
  
    
  ];

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

}
