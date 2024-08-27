# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
}
{
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
};


environment.systemPackages = with pkgs; [
   nur.repos.nltch.spotify-adblock    #for installing spotify-adblock
   nur.repos.nltch.ciscoPacketTracer8 #for installing packettracer8 
]

};
