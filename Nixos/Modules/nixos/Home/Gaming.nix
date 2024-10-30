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
# ryujinx
 inputs.suyu.packages.x86_64-linux.suyu
 ];
  

programs.steam = {
  enable = true;

 };

programs.appimage = {
  enable = true;
  binfmt = true;
};

}
