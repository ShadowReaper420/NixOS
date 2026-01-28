{ config, lib, pkgs, inputs, ... }:

{

  services.flatpak = {
    enable = true;
    remotes = [{
      name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];
    packages = [
    "com.github.unrud.VideoDownloader"
    #"com.github.Matoking.protontricks"
    "com.github.tchx84.Flatseal"
    #"at.vintagestory.VintageStory"


    ];
    update.onActivation = true;


  };

}
