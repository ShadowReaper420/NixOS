{config, lib, pkgs, ...}:

{ environment.systemPackages = with pkgs;[

  git
  wget
  kitty
  nil
  kdePackages.partitionmanager
  cpio
  cmake



]; 




  }
