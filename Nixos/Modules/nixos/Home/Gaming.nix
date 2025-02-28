{config, lib, pkgs, inputs, systemSettings, ...}:


{
environment.systemPackages = with pkgs;[
 gamescope
 #protontricks
  bottles
 prismlauncher
 steamtinkerlaunch 
 openmw
 winetricks
 wine
 lutris
 nexusmods-app-unfree
 ryujinx-greemdev
 protonup-qt
 inputs.suyu.packages.x86_64-linux.suyu
 xivlauncher
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
