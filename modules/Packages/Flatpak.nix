{ den, inputs, ... }: {

  flake-file = {
    
    inputs = {
      nix-flatpak = {
        url = "github:gmodena/nix-flatpak/?ref=latest";
      };
    };

  };

  den.aspects.flatpak = {

    nixos = {

      imports = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];

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
          "com.discordapp.Discord"
          #"com.valvesoftware.Steam"
          # "net.davidotek.pupgui2"    


        ];
        update.onActivation = true;


      };


    };
  };


}
