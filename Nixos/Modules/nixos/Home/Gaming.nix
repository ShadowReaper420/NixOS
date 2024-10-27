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
 lutris
# ryujinx
 ];
  

programs.steam = {
  enable = true;

 };

programs.appimage = {
  enable = true;
  binfmt = true;
};
}
