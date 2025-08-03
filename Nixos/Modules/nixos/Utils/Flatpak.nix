{ config, lib, pkgs, inputs, ... }:

{

  services.flatpak = {
    enable = true;
    remotes = [{
       name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
}];
    packages = [
      {appId = "com.github.unrud.VideoDownloader"; origin = "flathub";}
      "com.github.Matoking.protontricks"
      "com.github.tchx84.Flatseal"


];
     update.onActivation = true;


};

}
