{
  config,
  lib,
  pkgs,
  inputs,
  systemSettings,
  pkgs-stable,
  ...
}: {
  environment.systemPackages = 

  with pkgs; [
    
    
    bottles
    prismlauncher
    steamtinkerlaunch
    openmw
    winetricks
    wine
    #gamescope
    lutris
    nexusmods-app-unfree
    protonup-qt
    xivlauncher
   # ryubing
    
  ];
  
  


  programs.steam = {
    enable = true;
    #protontricks.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
