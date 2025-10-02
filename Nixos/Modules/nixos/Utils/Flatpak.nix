{ config, lib, pkgs, inputs, ... }:

{

  services.flatpak = {
    enable = true;
    #remotes = [{
      #name = "flathub"; location = "https://flathub.org/beta-repo/flathub.flatpakrepo";
    #}];
   # packages = [
    #"com.github.unrud.VideoDownloader"
    #"com.github.Matoking.protontricks"
    #"com.github.tchx84.Flatseal"


   # ];
    #update.onActivation = true;


  };

}
