{config, lib, pkgs, inputs, nur, ...}:

{

  environment.systemPackages = with pkgs; [
    config.nur.repos.nltch.spotify-adblock
    ];
}