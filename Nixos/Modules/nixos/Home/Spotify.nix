{config, lib, pkgs, nur, ...}:

{

  environment.systemPackages = [config.nur.repos.nltch.spotify-adblock];
}