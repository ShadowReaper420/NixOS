{config, lib, pkgs, inputs, ...}:

{

  environment.systemPackages = with pkgs; [
    nur.repos.nltch.spotify-adblock
    ];
}