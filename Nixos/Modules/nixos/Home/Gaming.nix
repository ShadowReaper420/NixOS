{config, lib, pkgs, ...}:


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
 ryujinx
];
  

programs.steam = {
  enable = true;

 };
}
