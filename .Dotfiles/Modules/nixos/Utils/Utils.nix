{config, lib, pkgs, ...}:

{ environment.systemPackages = with pkgs;[

git
wget
kitty
ranger



]; 




  }