{ config, lib, pkgs, inputs, ... }:

{

  services.flatpak = {
    enable = true;
    remotes = [{
       name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
}];
    packages = [
      {appId = "com.github.unrud.VideoDownloader"; origin = "flathub";}
      "io.github.ryubing.Ryujin"
];
     update.onActivation = true;


};

}
